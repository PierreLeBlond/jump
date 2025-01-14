using Godot;

public partial class PlayerTestingUi : Control
{
    [Export]
    public Slider JumpHeightSlider;

    [Signal]
    public delegate void JumpHeightChangedEventHandler(double value);

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        JumpHeightSlider.ValueChanged += (double value) =>
        {
            EmitSignal(SignalName.JumpHeightChanged, value);
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta) { }
}
