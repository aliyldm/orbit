package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.net.PetAssembly;
   
   public class PetRepairShipCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "PetRepairShipCommand";
      
      public function PetRepairShipCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         PetAssembly.getInstance().switchToShipRepairMode();
      }
   }
}

