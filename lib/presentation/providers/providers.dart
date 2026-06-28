import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../application/use_cases/swing_session/delete_swing_session_use_case.dart';
import '../../application/use_cases/swing_session/get_all_swing_sessions_use_case.dart';
import '../../application/use_cases/swing_session/get_swing_session_use_case.dart';
import '../../application/use_cases/swing_session/prepare_swing_clip_use_case.dart';
import '../../application/use_cases/swing_session/save_swing_session_use_case.dart';
import '../../data/repositories/swing_session_repository.dart';
import '../../data/services/camera_recording_service.dart';
import '../../data/services/database_service.dart';
import '../../data/services/impact_detection_service.dart';
import '../../data/services/video_storage_service.dart';
import '../../data/services/video_trim_service.dart';
import '../../domain/entities/swing_session.dart';
import '../../domain/repositories/i_swing_session_repository.dart';

// --- Infrastructure Providers (DI) ---

final databaseServiceProvider = Provider((_) => DatabaseService());

final videoStorageServiceProvider = Provider((_) => VideoStorageService());

final cameraRecordingServiceProvider = Provider((_) => CameraRecordingService());

final impactDetectionServiceProvider = Provider((_) => ImpactDetectionService());

final videoTrimServiceProvider = Provider((_) => VideoTrimService());

final swingSessionRepositoryProvider = Provider<ISwingSessionRepository>(
  (ref) => SwingSessionRepository(
    ref.watch(databaseServiceProvider),
    ref.watch(videoStorageServiceProvider),
  ),
);

// --- UseCase Providers ---

final saveSwingSessionUseCaseProvider = Provider(
  (ref) => SaveSwingSessionUseCase(ref.watch(swingSessionRepositoryProvider)),
);

final getAllSwingSessionsUseCaseProvider = Provider(
  (ref) =>
      GetAllSwingSessionsUseCase(ref.watch(swingSessionRepositoryProvider)),
);

final getSwingSessionUseCaseProvider = Provider(
  (ref) => GetSwingSessionUseCase(ref.watch(swingSessionRepositoryProvider)),
);

final deleteSwingSessionUseCaseProvider = Provider(
  (ref) =>
      DeleteSwingSessionUseCase(ref.watch(swingSessionRepositoryProvider)),
);

final prepareSwingClipUseCaseProvider = Provider(
  (ref) => PrepareSwingClipUseCase(
    ref.watch(impactDetectionServiceProvider),
    ref.watch(videoTrimServiceProvider),
    ref.watch(videoStorageServiceProvider),
  ),
);

// --- Async Data Providers ---

final allSwingSessionsProvider = FutureProvider<List<SwingSession>>(
  (ref) => ref.watch(getAllSwingSessionsUseCaseProvider).execute(),
);

final swingSessionProvider = FutureProvider.family<SwingSession, int>(
  (ref, id) => ref.watch(getSwingSessionUseCaseProvider).execute(id),
);

// --- UI State Providers ---

final playbackSpeedProvider = StateProvider<double>((_) => 1.0);
