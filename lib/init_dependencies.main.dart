part of 'init_dependencies.dart';
final serviceLocator = GetIt.instance;

Future<List<String>> loadAbusiveWords() async {
  final data = await rootBundle.loadString('assets/abusive_word.txt');
  return data
      .split('\n')
      .map((e) => e.trim().toLowerCase())
      .where((e) => e.isNotEmpty)
      .toList();
}

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  serviceLocator.registerLazySingleton(() => Supabase.instance.client);

  final path = (await getApplicationDocumentsDirectory()).path;
  Hive.init(path);
  final blogBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => blogBox);

  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(serviceLocator()),
  );

  // Profile Feature
  serviceLocator.registerFactory<ProfileRepository>(
        () => ProfileRepositoryImpl(),
  );

  serviceLocator.registerFactory(() => GetUserProfile(serviceLocator()));
  serviceLocator.registerFactory(() => UpdateUserProfile(serviceLocator()));
  serviceLocator.registerFactory(() => GetPostCount(serviceLocator()));

  serviceLocator.registerFactory(
        () => ProfileBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // Discover Feature
  serviceLocator.registerFactory<DiscoverRepository>(
        () => DiscoverRepositoryImpl(),
  );
  serviceLocator.registerFactory(() => GetAllUsersExceptCurrentUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => DiscoverBloc(serviceLocator()));
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
          () => AuthRepositoryImp(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
          () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
          () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
          () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        blogRepository: serviceLocator(),
      ),
    );
}
