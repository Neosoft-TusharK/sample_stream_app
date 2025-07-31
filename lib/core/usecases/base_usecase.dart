abstract class BaseUsecase<Success, Params> {
  Future<Success> call(Params params);
}
