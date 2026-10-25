package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.net.PetAssembly;
   
   public class ActivatePetCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "petAssembly";
      
      public function ActivatePetCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         PetAssembly.getInstance().togglePetActivation();
      }
   }
}

