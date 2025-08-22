import 'package:game_notion/models/game_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/remote/repositories/games/games_repository.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';

class GameServiceImpl implements GameService {
  final GameRepository gameRepository;

  GameServiceImpl({required this.gameRepository});

  @override
  Stream<List<GameSmallModel?>>? gamesStream() {
    return gameRepository.gamesStream();
  }

  @override
  Future<GameModel> getGameById({required int id}) {
    return gameRepository.getGameById(id: id);
  }

  @override
  Future<void> saveGame({required GameSmallModel game}) {
    return gameRepository.saveGame(game: game);
  }

  @override
  Future<List<GameSmallModel>> searchGames({required String q}) {
    return gameRepository.searchGames(q: q);
  }

  @override
  Future<void> removeGame({required int id}) {
    return gameRepository.removeGame(id: id);
  }
}
