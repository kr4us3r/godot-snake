# godot-snake
The classic snake game written (poorly) in Godot Engine with GDScript.

# Build

__If you've built at least one game with Godot Engine before, you can safely skip this step.__

First, you will need export templates for your target system.
Chances are you already have them. If not:
* Go to `Project -> Export`.
* There you'll see the message __Export templates for this platform are missing__. Follow the link `Manage Export templates`.
The following steps are pretty self-evident.

To build under Windows, the next step is to download `rcedit`. A safe option would be the `electron/rcedit`
repository. There, in `Releases`, download the `rcedit-x64.exe` file (or `rcedit-x86.exe` if, God forbid,
you run a 32-bit Windows machine and use the 32-bit version of Godot Engine).
Then follow the engine editor's recommended steps.

# Decrease the game binary's size

If you build the project as is, its size will be immense (around 65 MB, which is absurd for this tiny game). The reason is that the
entirety of the engine will be included in the compiled file. That is 2D physics, 3D physics, 3D graphics, OpenGL,
Vulkan, and all of the other stuff that is absolutely not necessary here (nor is it used).

To combat it I've created a custom engine build profile where I disabled all of that. You need to compile the engine
from source (refer to `Godot Engine Documentation -> Building from source`) with that profile to create a custom build template.

When you get a grasp of the process from the documentation, place `profile.build` into the root directory of the source code and enter the following command:

`scons p=*your_platform* target=template_release tools=no debug_symbols=no disable_3d=yes optimize=size disable_advanced_gui=yes build_feature_profile="profile.build"`

Then, when exporting the project, insert the resulting engine binary as a custom template: `Export -> Options -> Custom Template -> Release`. It helped me halve the
game's size (still a lot, but it's as far as I could get).

I used the latest version of the engine's source code at the time of writing, Godot Engine 4.2
