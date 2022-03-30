part of '../controller.dart';

class GeneralController extends StateNotifier<GeneralState> {
  GeneralController() : super(const GeneralState());

  // change_value function
  void updateTopToast({required bool value}) {
    state = state.copyWith(topToast: value);
    PrefManager().setBool(key: PrefKey.topToast, value: value);
    Logger.s(
      '- from GeneralState \n >> save bool toptoast = ${state.topToast}',
    );
  }

  void updateToastDuration({required int value}) {
    state = state.copyWith(toastDuration: value);
    PrefManager().setInt(key: PrefKey.toastDuration, value: value);
    Logger.s(
      '- from GeneralState'
      '\n >> save int toastDuration = ${state.toastDuration}',
    );
  }

  Future<void> whenHome() async {
    await runFAB();
    updateShowFAB(value: true);
    await Wakelock.disable();
    state = state.copyWith(opacity: 1);
    state = state.copyWith(status: t.greetings.t);

    await Future<void>.delayed(const Duration(seconds: 2));
    await updateStatus(text: DateTime.now().format('yMMMMEEEEd', t.lang.t));
  }

  Future<void> whenExpand() async {
    updateShowFAB(value: false);
    await Wakelock.enable();
    await updateStatus(text: '置き時計モード');
    await Future<void>.delayed(const Duration(seconds: 3));
    await updateStatus(
      text: '${DateTime.now().format('yMMMMEEEEd', t.lang.t)}'
          '・${AppDataStore().versionStr}',
    );
  }

  Future<void> updateStatus({required String text}) async {
    state = state.copyWith(opacity: 0);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(opacity: 1);
    state = state.copyWith(status: text);
  }

  void runPush({
    required BuildContext context,
    required Widget page,
    required bool isReplace,
  }) =>
      !isReplace
          ? Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => page,
              ),
            )
          : Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(builder: (context) => page),
              (_) => false,
            );

  Future<void> runFAB() async {
    state = state.copyWith(showFAB: false);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(showFAB: true);
  }

  void updateShowFAB({required bool value}) =>
      state = state.copyWith(showFAB: value);

  Future<void> runURL({required String url}) async {
    await launch(url);
  }
}