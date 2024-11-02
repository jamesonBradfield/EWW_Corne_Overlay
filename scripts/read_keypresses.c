#include <linux/input.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define DEVICE_PATH "/dev/input/event9" // Replace X with your keyboard device number

int main() {
    int fd;
    struct input_event event;

    // Open the input device
    fd = open(DEVICE_PATH, O_RDONLY);
    if (fd < 0) {
        perror("Failed to open device");
        exit(1);
    }

    // Read events from the device
    while (1) {
        if (read(fd, &event, sizeof(event)) < 0) {
            perror("Failed to read event");
            exit(1);
        }

				// Check if the event is a key press
				if (event.type == EV_KEY) {
						printf("{\"key_code\": %d, \"event_value\": %d}\n", event.code, event.value);
						fflush(stdout);
				}
    }

    close(fd);
    return 0;
}
