#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define BINGO_SIZE 5

struct scard
{
    int card[BINGO_SIZE][BINGO_SIZE];
};

int fpeek(FILE *stream)
{
    int c;

    c = fgetc(stream);
    ungetc(c, stream);

    return c;
}

int get_nums(FILE *f, int *nums)
{
    char nums_str[1000];
    fgets(nums_str, 1000, f);

    int index = 0;
    char *token = strtok(nums_str, ",");

    while (token != NULL)
    {
        nums[index] = atoi(token);
        index++;
        token = strtok(NULL, ",");
    }

    return index;
}

bool check_bingo(int card[BINGO_SIZE][BINGO_SIZE])
{
    for (int i = 0; i < BINGO_SIZE; i++)
    {
        if (card[i][0] == -1 && card[i][1] == -1 && card[i][2] == -1 && card[i][3] == -1 && card[i][4] == -1)
            return true;

        if (card[0][i] == -1 && card[1][i] == -1 && card[2][i] == -1 && card[3][i] == -1 && card[4][i] == -1)
            return true;
    }
    return false;
}

int sum_bingo(int card[BINGO_SIZE][BINGO_SIZE])
{
    int sum = 0;
    for (int i = 0; i < BINGO_SIZE; i++)
    {
        for (int j = 0; j < BINGO_SIZE; j++)
        {
            if (card[i][j] != -1)
                sum += card[i][j];
        }
    }

    return sum;
}

bool is_in_array(int value, int arr[], int len)
{
    for (int i = 0; i < len; i++)
    {
        if (value == arr[i])
            return true;
    }

    return false;
}

// everything in main for speed
int main()
{
    const char *filename = "input";
    const char mode = 'r';
    FILE *f = fopen(filename, &mode);

    int nums[1000];
    int length = get_nums(f, nums);

    struct scard cards[1000];
    char card_str[BINGO_SIZE][1000];
    int card[BINGO_SIZE][BINGO_SIZE];
    int card_index = 0;

    while (fpeek(f) != EOF)
    {
        // discard empty line
        char line[1000];
        fgets(line, 1000, f);

        for (int i = 0; i < BINGO_SIZE; i++)
        {
            fgets(card_str[i], 1000, f);
        }

        for (int i = 0; i < BINGO_SIZE; i++)
        {
            // always give a const * to strtok
            char *token = strtok(card_str[i], " ");
            int index = 0;
            while (token != NULL)
            {
                card[i][index] = atoi(token);
                index++;
                token = strtok(NULL, " ");
            }
        }

        struct scard current_card;
        memcpy(&current_card.card, card, BINGO_SIZE * BINGO_SIZE * sizeof(int));
        cards[card_index] = current_card;

        card_index++;
    }

    int number_of_cards = card_index;
    int winners[number_of_cards];

    // initialize winners to avoid looking up garbage values later
    for (int i = 0; i < number_of_cards; i++)
        winners[i] = -1;

    int win_index = 0;
    bool winner_found = false;

    // i = index of the drawn number in nums[]
    for (int i = 0; i < length; i++)
    {
        int drawn = nums[i];

        // j = index of the examined card in cards[]
        for (int j = 0; j < number_of_cards; j++)
        {
            if (is_in_array(j, winners, win_index + 1))
                continue;

            int card_examined[BINGO_SIZE][BINGO_SIZE];
            memcpy(card_examined, cards[j].card, BINGO_SIZE * BINGO_SIZE * sizeof(int));

            for (int row = 0; row < BINGO_SIZE; row++)
            {
                for (int column = 0; column < BINGO_SIZE; column++)
                {
                    if (card_examined[row][column] == drawn)
                        card_examined[row][column] = -1;
                }
            }

            memcpy(cards[j].card, card_examined, BINGO_SIZE * BINGO_SIZE * sizeof(int));

            if (check_bingo(card_examined))
            {
                // first winner found
                if (!winner_found)
                {
                    winner_found = true;
                    printf("Part 1: %d\n", sum_bingo(card_examined) * drawn);
                }

                winners[win_index] = j;
                win_index++;

                // last winner found
                if (win_index == number_of_cards)
                    printf("Part 2: %d\n", sum_bingo(card_examined) * drawn);
            }
        }
    }
}