package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public interface IKeyboardCommand
   {
      
      function execute(param1:Map, param2:Vector.<String>) : void;
   }
}

