using System;
using Godot;

public partial class TestingSlider : Node
{
    [Export]
    public string Label { get; set; }

    [Export]
    public float MinValue { get; set; }

    [Export]
    public float MaxValue { get; set; }

    [Export]
    public float Step { get; set; }

    [Signal]
    public delegate void ValueChangedEventHandler(float value);

    public void Init(float initialValue)
    {
        var slider = GetNode<Slider>("Slider");

        slider.Step = Step;
        slider.Value = initialValue;
        slider.MinValue = MinValue;
        slider.MaxValue = MaxValue;

        var label = GetNode<Label>("TopContainer/Label");
        label.Text = Label;

        var valueLabel = GetNode<Label>("TopContainer/ValueLabel");
        valueLabel.Text = initialValue.ToString();

        var minLabel = GetNode<Label>("BottomContainer/MinLabel");
        minLabel.Text = MinValue.ToString();

        var maxLabel = GetNode<Label>("BottomContainer/MaxLabel");
        maxLabel.Text = MaxValue.ToString();

        slider.ValueChanged += (double value) =>
        {
            EmitSignal(nameof(ValueChanged), value);
            valueLabel.Text = Math.Round(value, 2).ToString();
        };
    }
}
