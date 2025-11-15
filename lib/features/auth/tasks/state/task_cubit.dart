import 'package:bloc/bloc.dart';
import '../models/task.dart';

class TasksCubit extends Cubit<List<Task>> {
  TasksCubit() : super([]);

  void loadInitial(List<Task> tasks) {
    emit(tasks);
  }

  void addTask(Task task) {
    emit([...state, task]);
  }

  void toggleTask(String id) {
    emit(state.map((t) {
      if (t.id == id) {
        return t.copyWith(isCompleted: !t.isCompleted);
      }
      return t;
    }).toList());
  }

  void deleteTask(String id) {
    emit(state.where((t) => t.id != id).toList());
  }
}
