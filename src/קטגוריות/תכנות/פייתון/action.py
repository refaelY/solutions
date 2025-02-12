class ShapeObject:
    def __init__(self, name, image_path, description, action):
        self.name = name
        self.image_path = image_path
        self.description = description
        self.action = action

    def display_info(self):
        """Prints the object's information"""
        print(f"Name: {self.name}")
        print(f"Description: {self.description}")
        print(f"Image Path: {self.image_path}")

    def perform_action(self):
        """Executes the object's action"""
        print(f"Performing action: {self.action}")
        # Here you can define specific logic for each shape
        if self.action == 'draw':
            self.draw()

    def draw(self):
        """Placeholder method to simulate drawing the shape"""
        print(f"Drawing {self.name} on the canvas.")

# Example usage for a square
square = ShapeObject(
    name="מרובע",
    image_path="assets/icons/shapes/square_icon.png",
    description="אובייקט ריבוע פשוט",
    action="draw"
)

# Display the square's information and perform its action
square.display_info()
square.perform_action()
