import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class DecisionHelperScreen extends StatefulWidget {
  const DecisionHelperScreen({super.key});

  @override
  State<DecisionHelperScreen> createState() => _DecisionHelperScreenState();
}

class _DecisionHelperScreenState extends State<DecisionHelperScreen> {
  final Map<int, bool?> answers = {};
  bool showResult = true;

  void _onAnswer(int index, bool answer) {
    setState(() {
      answers[index] = answer;
      showResult = true;
    });
  }

  void _closeResult() {
    setState(() {
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool allAnswered =
        answers.length == scamDetectionQuestions.length &&
        !answers.values.contains(null);

    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          title: 'Decision Helper',
          icon: Icons.help_outline,
          screen: HomeScreen(initialIndex: 3),
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                InfoHeaderMessage(
                  message:
                      'Answer these questions to help determine if you\'re dealing with a scam.',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: scamDetectionQuestions.length,
                    itemBuilder: (context, i) {
                      final selected = answers[i];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected != null
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  )
                                : Colors.grey.shade200,
                            width: selected != null ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scamDetectionQuestions[i],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onAnswer(i, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected == true
                                            ? theme.colorScheme.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: selected == true
                                              ? theme.colorScheme.primary
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      child: Text(
                                        'Yes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selected == true
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onAnswer(i, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected == false
                                            ? theme.colorScheme.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: selected == false
                                              ? theme.colorScheme.primary
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      child: Text(
                                        'No',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: selected == false
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (allAnswered && showResult)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16, bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: getScamDetectionResultColor(
                        answers,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: getScamDetectionResultColor(
                          answers,
                        ).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: _closeResult,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: getScamDetectionResultColor(
                                    answers,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: getScamDetectionResultColor(answers),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Icon(
                          getScamDetectionResultIcon(answers),
                          color: getScamDetectionResultColor(answers),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          getScamDetectionResult(answers),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: getScamDetectionResultColor(answers),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
