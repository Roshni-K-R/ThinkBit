part of 'init_dependencies.dart';
final serviceLocator = GetIt.instance;


Future<List<String>> loadAbusiveWords() async {
  final data = await rootBundle.loadString('assets/abusive_word.txt');
  return data
      .split('\n')
      .map((e) => e.trim().toLowerCase())
      .where((e) => e.isNotEmpty) // ✅ filter out blank lines
      .toList();
}



Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  _initProfile();

  // Supabase Client
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);

  // Hive
  final path = (await getApplicationDocumentsDirectory()).path;
  Hive.init(path);
  final blogBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => blogBox);

  // Internet checker
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));

  // App-level cubit
  serviceLocator.registerLazySingleton(() => AppUserCubit());
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
    ..registerLazySingleton(() => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ));
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
    ..registerLazySingleton(() => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
      blogRepository: serviceLocator(),
    ));
}

void _initProfile() {
  // Repository
  serviceLocator.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  // Use Cases
  serviceLocator.registerFactory(() => GetUserProfile(serviceLocator()));
  serviceLocator.registerFactory(() => UpdateUserProfile(serviceLocator()));

  // Bloc
  serviceLocator.registerFactory(() => ProfileBloc(
    serviceLocator(), // GetUserProfile
    serviceLocator(), // UpdateUserProfile
  ));
}
