import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/features/authentication/data/repo_impl/authentication_repo_impl.dart';
import 'package:fluttersampleapp/features/authentication/domain/repo/authentication_repo.dart';
import 'package:fluttersampleapp/features/authentication/domain/usecase/authentication_usecase.dart';
import 'package:fluttersampleapp/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt authGetIt = GetIt.instance;

Future<void> setupAuthGetIt() async {
  authGetIt.registerFactory<AuthenticationCubit>(
    () => AuthenticationCubit(
      iPreference: globalGetIt(),
      authenticationUseCase: authGetIt(),
    ),
  );

  authGetIt.registerFactory<AuthenticationRepo>(
    () => AuthenticationRepoImpl(remoteDataSource: globalGetIt()),
  );

  authGetIt.registerFactory<AuthenticationUseCase>(
    () => AuthenticationUseCase(globalGetIt()),
  );
}
