# Free File Share Between Devices — Project Plan

> Status: v1 · Phase 0 done · Phase 1 next
> Scope of first release: **Windows desktop app + Android mobile app**

---

## 1. The idea

### 1.1 The problem

Moving files between a phone and a computer is still harder than it should be:

- **Cables (MTP)** are slow to browse and unreliable, and they behave differently on every phone.
- **Cloud drives / messaging apps** (Drive, WhatsApp, Telegram, email) upload the file to the internet and download it again. That is slow, needs data, compresses photos and videos, and sends private files to a third party.
- **Bluetooth file transfer** in Windows is hidden, slow and frequently fails.
- **Vendor tools** (Phone Link, Quick Share, AirDrop) only work inside one ecosystem or one brand.

### 1.2 The solution

Two apps — one on the computer, one on the phone — that find each other and move files **directly between the devices**, without the internet, using whichever connection is available:

| Connection | When it is used | Typical speed |
|---|---|---|
| **Wi-Fi (same network)** | Default — both devices on the same router | 20–80 MB/s |
| **Direct Wi-Fi (no router)** | Outdoors, office Wi-Fi that blocks devices, no network at all | 10–40 MB/s |
| **USB cable** | User prefers a cable, or Wi-Fi is not allowed | 20–40 MB/s |
| **Bluetooth** | Finding nearby devices, pairing, small files when nothing else works | 0.1–0.2 MB/s |

The user chooses the connection, or lets the app pick the fastest one available.

### 1.3 Core principles

1. **Local only.** Files never touch a server. No account, no sign-up.
2. **Secure by default.** Every connection is end-to-end encrypted, and a device must be paired (approved with a code) before it can send anything.
3. **Transport-independent.** Wi-Fi, cable and Bluetooth are interchangeable "pipes". Everything above them (pairing, transfers, history) is written once.
4. **Fast and reliable.** Original quality, no compression, resumable transfers, verified with checksums.
5. **Simple.** Pair once; after that, sending is drag-and-drop on Windows and "Share → app" on Android.

### 1.4 Main user flows

**First-time pairing**

1. Open both apps. The phone sees the computer in a "Nearby devices" list (and vice versa).
2. Tap the computer on the phone. *Or* scan the QR code shown on the computer.
3. Both screens show the same **6-digit code**. The user confirms it matches on both.
4. Devices are now **trusted** and remember each other.

**Sending a file (phone → PC)**

1. Share a photo from the gallery → choose the app → choose the PC.
2. The PC shows "Phone wants to send 3 files (45 MB)" → Accept (or auto-accept for trusted devices).
3. Progress shows on both devices. The files land in the chosen download folder on the PC.

**Sending a file (PC → phone)**

1. Drag files onto the app window (or the tray icon), pick the phone.
2. The phone shows a notification → Accept → files saved to `Downloads/<AppName>`.

### 1.5 Feature list (full vision)

| Area | Features |
|---|---|
| Discovery | Auto-discover devices on Wi-Fi; QR code connect; manual IP entry; Bluetooth discovery |
| Pairing | 6-digit code check; QR pairing; trusted-device list; rename / revoke devices |
| Transfer | Files, multiple files, folders; send queue; pause / resume / cancel; checksum verification; accept / decline; auto-accept for trusted devices |
| Connections | Wi-Fi LAN, Direct Wi-Fi (hotspot), USB cable, Bluetooth; automatic best-connection choice |
| Android | Share-sheet target; notifications with progress; background transfers; choose save folder |
| Windows | Drag-and-drop; system tray; start with Windows; choose download folder; "Send to" context menu |
| Extras (later) | Clipboard sync; send text / links; transfer history; macOS and iOS apps |

---

## 2. Technology choices

| Concern | Choice | Notes |
|---|---|---|
| Framework | **Flutter** (Windows + Android first, macOS / iOS later) | One language, one codebase for both apps |
| Monorepo | **Melos** + Dart pub workspaces | Melos 8 — config lives in the root `pubspec.yaml` under `melos:` |
| Architecture | **Clean Architecture + DDD** (presentation / domain / data per feature) | |
| State management | **flutter_bloc** + **freezed** | Immutable states and events, union types |
| Dependency injection | **get_it** + **injectable** | Code-generated; each package exposes its own module |
| Navigation | **auto_route** | Type-safe routes |
| Error handling | **fpdart** — `Either<Failure, T>` / `TaskEither<Failure, T>` | Convention: *Left = failure, Right = success* |
| Models / serialization | **freezed** + **json_serializable**; **protobuf** for the wire protocol | Protobuf gives a compact, versionable binary format |
| Crypto | **cryptography** package (X25519, Ed25519, HKDF, ChaCha20-Poly1305) | |
| Local database | **drift** (SQLite) | Trusted devices, transfer history, settings |
| Secret storage | **flutter_secure_storage** | Device private key (Android Keystore / Windows Credential Manager) |
| Discovery | **nsd** (mDNS / DNS-SD) + UDP broadcast fallback | |
| Logging | **talker** (or `logger`) | In-app log viewer helps debugging on real devices |
| Testing | `test`, `bloc_test`, `mocktail`, `integration_test` | |

### About Dio + Retrofit

The reference architecture uses **Dio + Retrofit** for REST APIs. This app has **no backend server** — devices talk directly over sockets — so the "api_client" role is taken by the **protocol** and **transport** packages. The same ideas still apply (interceptors become *channel middleware* for logging / encryption / metrics, and errors are still returned as `Either`). Dio can be added later if we need an online feature such as update checks.

---

## 3. System architecture

### 3.1 Layered view (inside each app)

```
┌──────────────────────────────────────────────────────────────┐
│  apps/desktop (Windows)            apps/mobile (Android)       │  ← thin shells: entry point,
│                                                                │    platform setup, routing
├──────────────────────────────────────────────────────────────┤
│  FEATURES  (each: presentation / domain / data)                │
│  onboarding · discovery · pairing · transfer · history ·       │
│  settings                                                      │
├──────────────────────────────────────────────────────────────┤
│  CONNECTIVITY                                                  │
│  ┌────────────────────────────────────────────────────────┐   │
│  │ session  – connection manager, best-transport choice   │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │ protocol – messages, framing, transfer state machine   │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │ secure_channel – handshake + encryption (any pipe)     │   │
│  ├────────────────────────────────────────────────────────┤   │
│  │ transport (interface)                                  │   │
│  │  ├─ transport_lan        (TCP + mDNS/UDP)              │   │
│  │  ├─ transport_hotspot    (Android local-only hotspot)  │   │
│  │  ├─ transport_usb        (USB tethering / ADB)         │   │
│  │  └─ transport_bluetooth  (BLE / RFCOMM)                │   │
│  └────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────┤
│  CORE: foundation (Either, Failure, logger) · design_system ·  │
│        di · storage · platform (permissions, file system)      │
└──────────────────────────────────────────────────────────────┘
```

**Dependency rule:** arrows only point *down*. Features never import a concrete transport; they only see the `session` and `protocol` APIs. Domain layers never import Flutter.

### 3.2 Why "transport-independent" is the key design decision

Every connection type is reduced to the same small interface:

```dart
abstract interface class Transport {
  TransportKind get kind;                       // lan, hotspot, usb, bluetooth
  Stream<DiscoveredPeer> discover();            // find nearby devices
  Future<void> advertise(LocalDeviceInfo me);   // make this device visible
  TaskEither<TransportFailure, RawConnection> connect(PeerAddress address);
  Stream<RawConnection> incoming();             // accept connections
}

abstract interface class RawConnection {
  Stream<Uint8List> get input;
  Future<void> write(Uint8List bytes);
  Future<void> close();
}
```

Encryption, pairing, file transfer, resume, history and the whole UI are written **once** on top of `RawConnection`. Adding Bluetooth or USB later means writing one new package — nothing else changes.

### 3.3 How each connection works

**Wi-Fi LAN (Phase 1)**
- Each app advertises itself with mDNS service `_ffshare._tcp` (name, device type, ID fingerprint, port).
- UDP broadcast on a fixed port as a fallback for routers that block mDNS.
- Data over a plain TCP socket; the secure channel (3.4) encrypts it.
- Manual "Connect by IP" and QR code (contains IP, port, key fingerprint) for networks where discovery is blocked.

**Direct Wi-Fi / no router (Phase 4)**
- Android creates a *local-only hotspot* (`WifiManager.startLocalOnlyHotspot`, needs a small Kotlin platform channel).
- Phone shows a QR code with the hotspot name, password and address. Windows connects to that hotspot (via the native Wi-Fi API), then the normal LAN transport runs on top.

**USB cable (Phase 3)**
- **Recommended: USB tethering.** When the user turns on USB tethering, the cable becomes a private network between PC and phone; the LAN transport then works unchanged and fast. The app guides the user to the setting and detects the new network.
- **Advanced: ADB.** For developers with USB debugging on, the desktop app can use `adb reverse` port forwarding. Optional, never required.

**Bluetooth (Phase 5)**
- **"Bluetooth finds, Wi-Fi carries"** (the same idea Quick Share and AirDrop use): BLE is used to find nearby devices and exchange connection details, then the transfer switches to the fastest Wi-Fi path.
- Bluetooth Classic (RFCOMM) as a slow fallback for small files when no Wi-Fi path exists.
- Windows Bluetooth needs a native C++/WinRT plugin (`Windows.Devices.Bluetooth`); Android uses existing plugins plus a little Kotlin for advertising.

### 3.4 Security design

| Item | Design |
|---|---|
| Device identity | Each install generates an **Ed25519 key pair** on first launch. Private key stays in secure storage. The device ID is a fingerprint of the public key. |
| Pairing | Both devices run an **X25519 key exchange**, sign it with their identity keys, and display a **6-digit code** derived from the shared secret (Short Authentication String). The user confirms both codes match, which defeats man-in-the-middle attacks. QR pairing carries the fingerprint directly, so no code check is needed. |
| Trust | Paired devices store each other's public key. Unknown devices can be *seen* but cannot send anything until paired. Devices can be revoked. |
| Every session | A fresh ephemeral key exchange per connection, modelled on the **Noise XX** handshake pattern → forward secrecy. |
| Encryption | **ChaCha20-Poly1305** on every frame, with counters to block replays. Works the same over TCP, USB and Bluetooth. |
| Integrity | SHA-256 per file, checked before the file is moved to its final location. |
| Hardening | Only accept in-app pairing; rate-limit pairing attempts; sanitize received file names (no `../`, no reserved Windows names); max-size and free-space checks before accepting. |

> The handshake should follow the published Noise specification closely and get an independent review before public release — custom crypto protocols are easy to get subtly wrong.

### 3.5 Wire protocol

Every message is a length-prefixed, encrypted **frame** containing a protobuf message:

```
[ 4-byte length ][ encrypted payload: type + protobuf body ]
```

| Message | Purpose |
|---|---|
| `Hello` | Protocol version, device name, type, capabilities |
| `PairRequest` / `PairConfirm` / `PairReject` | Pairing |
| `TransferOffer` | Manifest: list of files (name, size, relative path, MIME type) |
| `TransferAccept` / `TransferDecline` | Receiver's answer, including resume offsets for partial files |
| `FileChunk` | Transfer ID, file index, offset, bytes (256 KB – 1 MB) |
| `ChunkAck` | Flow control / back-pressure window |
| `FileComplete` | SHA-256 for verification |
| `Pause` / `Resume` / `Cancel` | Transfer control |
| `Ping` / `Pong` | Keep-alive and connection-loss detection |

**Transfer state machine**

```
 offered ──accept──► transferring ──all files verified──► completed
    │                  │    ▲
 decline            pause  resume
    ▼                  ▼    │
 declined            paused ┘        any state ──error / cancel──► failed / cancelled
```

Received data is written to `<name>.part`; on hash match it is renamed. If the connection drops, the next `TransferAccept` reports how many bytes already exist and the sender continues from there.

### 3.6 Platform specifics

**Android**
- Permissions: `NEARBY_WIFI_DEVICES` (13+), `BLUETOOTH_SCAN / CONNECT / ADVERTISE` (12+), `POST_NOTIFICATIONS` (13+), `ACCESS_FINE_LOCATION` (older versions for Wi-Fi/BT scanning).
- **Foreground service** so long transfers continue when the screen is off.
- Save files via **MediaStore** (Downloads / Pictures) or a folder the user picks with the Storage Access Framework.
- Receive shares from other apps (share-sheet intent).
- Wi-Fi multicast lock while discovering.

**Windows**
- Firewall: first launch triggers the Windows firewall prompt; the installer can add a rule.
- System tray, minimize to tray, start with Windows.
- Drag-and-drop onto the window.
- Packaging as **MSIX** (or an Inno Setup `.exe`); later an Explorer "Send to" entry.

---

## 4. Repository structure (Melos monorepo)

```
free_files_share_between_devices/
├── pubspec.yaml                 # workspace root + melos config
├── analysis_options.yaml        # shared lint rules
├── docs/                        # this plan, ADRs, protocol spec
├── apps/
│   ├── desktop/                 # Windows app (later macOS)
│   └── mobile/                  # Android app (later iOS)
├── packages/
│   ├── core/
│   │   ├── foundation/          # Failure types, Either helpers, logger, extensions (pure Dart)
│   │   ├── design_system/       # theme, colors, typography, reusable widgets
│   │   ├── di/                  # get_it setup, shared injectable modules
│   │   ├── storage/             # drift database, secure storage wrappers
│   │   └── platform/            # permissions, file system, device info abstractions
│   ├── connectivity/
│   │   ├── transport/           # Transport / RawConnection interfaces (pure Dart)
│   │   ├── transport_lan/
│   │   ├── transport_hotspot/
│   │   ├── transport_usb/
│   │   ├── transport_bluetooth/
│   │   ├── secure_channel/      # identity keys, handshake, frame encryption (pure Dart)
│   │   ├── protocol/            # protobuf messages, framing, transfer state machine (pure Dart)
│   │   └── session/             # connection manager, picks best transport
│   ├── features/
│   │   ├── onboarding/
│   │   ├── discovery/
│   │   ├── pairing/
│   │   ├── transfer/
│   │   ├── history/
│   │   └── settings/
│   └── navigation/              # auto_route router + route guards shared by both apps
└── tools/                       # scripts (codegen, protobuf generation, release)
```

**Why two app shells instead of one app?** Desktop and mobile have very different UX (tray + drag-drop + big windows vs. share-sheet + notifications + background service) and different native plugins. Both shells are thin: they wire DI, pick layouts and register platform-only modules. **About 90 % of the code lives in shared packages.**

### 4.1 Inside a feature package (example: `transfer`)

```
packages/features/transfer/
├── lib/
│   ├── transfer.dart                      # public exports only
│   └── src/
│       ├── domain/
│       │   ├── entities/                  # Transfer, TransferItem, TransferProgress (freezed)
│       │   ├── value_objects/             # FileSize, TransferId, SafeFileName
│       │   ├── failures/                  # TransferFailure (freezed union)
│       │   ├── repositories/              # abstract TransferRepository
│       │   └── usecases/                  # SendFiles, AcceptOffer, PauseTransfer, ...
│       ├── data/
│       │   ├── datasources/               # protocol session source, local history source
│       │   ├── models/                    # DTOs + mappers to entities
│       │   └── repositories/              # TransferRepositoryImpl → Either<Failure, T>
│       ├── presentation/
│       │   ├── bloc/                      # TransferBloc, events, states (freezed)
│       │   ├── pages/
│       │   └── widgets/
│       └── di/                            # @module for injectable
└── test/
```

### 4.2 Error handling convention

```dart
@freezed
sealed class TransferFailure with _$TransferFailure {
  const factory TransferFailure.peerDisconnected() = _PeerDisconnected;
  const factory TransferFailure.declinedByPeer() = _Declined;
  const factory TransferFailure.notEnoughSpace({required int needed}) = _NoSpace;
  const factory TransferFailure.checksumMismatch(String fileName) = _Checksum;
  const factory TransferFailure.unexpected(Object error) = _Unexpected;
}

abstract interface class TransferRepository {
  TaskEither<TransferFailure, TransferId> sendFiles(PeerId to, List<LocalFile> files);
  Stream<TransferProgress> watch(TransferId id);
}
```

Exceptions are caught at the **data** layer and turned into `Failure` values; the domain and presentation layers never see raw exceptions.

---

## 5. Phased implementation

Each phase ends with something that runs on a real Windows PC and a real Android phone.

### Phase 0 — Foundation
- Upgrade the Flutter SDK (the current one can't resolve `sdk: ^3.13.1`).
- Convert the repo into a Melos workspace; create `apps/desktop`, `apps/mobile` and the empty package skeletons.
- Shared lints, codegen scripts (`build_runner`, protobuf), Melos scripts (`analyze`, `test`, `gen`, `format`).
- Design system v1: theme, colors, typography, buttons, device card, progress tile.
- DI, logging, auto_route skeleton; both apps launch to a placeholder home screen.
- Real app name and package ID (replace `com.example...`).
- CI with GitHub Actions: analyze + test on every push.

**Done when:** `melos bootstrap && melos run test` passes; both apps start on their platforms.

### Phase 1 — Wi-Fi MVP (the core product)
- `transport` interface + `transport_lan` (TCP, mDNS, UDP fallback, manual IP).
- `secure_channel`: identity keys, handshake, encrypted frames.
- `protocol`: messages, framing, transfer state machine.
- Features: discovery list, pairing with 6-digit code + QR, send/receive files both ways, accept/decline, progress, save location.

**Done when:** a paired phone and PC on the same Wi-Fi can send a 1 GB file both ways, encrypted and checksum-verified.

### Phase 2 — Reliability and everyday use
- Resume after disconnect; pause/cancel; multiple files and folders; send queue.
- Transfer history (drift); trusted-device management; auto-accept.
- Android: share-sheet target, foreground service, notifications.
- Windows: drag-and-drop, system tray, start with Windows, installer.

**Done when:** pulling the Wi-Fi mid-transfer and reconnecting finishes the transfer without starting again.

### Phase 3 — USB cable
- Detect a USB-tethering network and guide the user to enable it; prefer it when present.
- Optional ADB mode for advanced users.

### Phase 4 — Direct Wi-Fi (no router)
- Android local-only hotspot + QR; Windows joins it; transfer over the LAN transport.

### Phase 5 — Bluetooth
- BLE discovery and connection hand-off to Wi-Fi.
- Bluetooth Classic fallback for small files (native Windows plugin).
- `session`: automatically choose the best available transport and switch during a transfer if one drops.

### Phase 6 — Extras and growth
- Clipboard sync, send text/links.
- macOS and iOS apps (mostly new app shells + platform transports).
- Store releases (Play Store, Microsoft Store), auto-update, crash reporting (opt-in).

---

## 6. Quality and testing

| Layer | How it is tested |
|---|---|
| `protocol`, `secure_channel`, `foundation` | Pure Dart unit tests; known-answer tests for crypto; fuzz tests for the frame parser |
| Transfer logic | An in-memory `LoopbackTransport` runs two "devices" inside one test — full send / resume / cancel scenarios with no network |
| Repositories | Unit tests with `mocktail` |
| Blocs | `bloc_test` for every event → state sequence |
| UI | Widget tests and golden tests for design-system components |
| End-to-end | `integration_test` on a real Android device and the Windows app on the same network |

**Targets:** ≥ 80 % coverage on domain + protocol packages; a 1 GB transfer over 5 GHz Wi-Fi in under 1 minute; ≤ 5 seconds from opening the app to seeing a paired device.

---

## 7. Risks and how we handle them

| Risk | Mitigation |
|---|---|
| Routers / office networks block mDNS or device-to-device traffic | UDP fallback, manual IP, QR connect, Direct Wi-Fi mode (Phase 4) |
| Windows firewall blocks incoming connections | Installer adds a firewall rule; clear in-app help |
| Android kills background transfers | Foreground service; battery-optimisation guidance |
| Flutter has weak Bluetooth support on Windows | Bluetooth is a late phase, used mainly to hand off to Wi-Fi; native plugin written then |
| Mistakes in custom crypto | Follow the Noise spec, use the audited `cryptography` primitives, external review before release |
| Large files exhaust memory | Stream chunks from disk; never load whole files into memory; back-pressure via `ChunkAck` |
| Protocol changes break older apps | Version field in `Hello`; capability flags; protobuf keeps old fields compatible |

---

## 8. Decisions

| Decision | Choice |
|---|---|
| App name | **Free File Share** (`freefileshare`) |
| Package ID | `com.manishsubah.freefileshare` |
| Package prefix | `ffs_` (e.g. `ffs_transfer`) |
| Minimum Android | 8.0 (API 26) |
| Minimum Windows | 10 (1809+) |
| Licence | Closed for now — decide before any public release |
| Flutter SDK | 3.47.1 (Dart 3.13.1) |
| Generated code | Committed to git; CI fails if it is out of date |

Still open: default save folders (proposed `Downloads/Free File Share` on both platforms).
