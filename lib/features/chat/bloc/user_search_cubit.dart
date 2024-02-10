import 'package:bcsports_mobile/features/chat/data/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_search_state.dart';

class UserSearchCubit extends Cubit<UserSearchState> {
  final ChatRepository chatRepository;

  UserSearchCubit({required this.chatRepository}) : super(UserSearchInitial());

  Future<void> init() async{
    emit(UserSearchLoadingState());

    try{
      await chatRepository.getAllUsers();
      emit(UserSearchSuccessState());
    }
    catch (e){
      emit(UserSearchFailState());
    }
  }

  void searchByString(String query) {
    emit(UserSearchLoadingState());

    try{
      chatRepository.filterUserByInputText(query);
      emit(UserSearchSuccessState());
    }
    catch (e){
      emit(UserSearchFailState());
    }
  }
}