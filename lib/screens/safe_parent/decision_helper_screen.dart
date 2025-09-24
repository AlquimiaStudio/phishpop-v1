import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';

class DecisionHelperScreen extends StatefulWidget {
  const DecisionHelperScreen({super.key});

  @override
  State<DecisionHelperScreen> createState() => _DecisionHelperScreenState();
}

class _DecisionHelperScreenState extends State<DecisionHelperScreen> {
  final Map<int, bool?> answers = {};

  void _onAnswer(int index, bool answer) {
    setState(() {
      answers[index] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool allAnswered =
        answers.length == scamDetectionQuestions.length &&
        !answers.values.contains(null);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: SecondaryAppbar(
        title: 'Decision Helper',
        icon: Icons.help_outline,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
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
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scamDetectionQuestions[i],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _onAnswer(i, true),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: selected == true
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: selected == true
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => _onAnswer(i, false),
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: selected == false
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: selected == false
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (allAnswered)
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
                        fontWeight: FontWeight.bold,
                        color: getScamDetectionResultColor(answers),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
