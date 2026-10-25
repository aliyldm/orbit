package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetBuffCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetBuffHandler extends BaseHandler
   {
      
      public function PetBuffHandler()
      {
         super();
      }
      
      public static function run(param1:PetBuffCommand) : void
      {
         var _loc2_:int = param1.effectAction;
         var _loc3_:int = param1.effectId;
         var _loc4_:Vector.<int> = param1.addingParameters;
         if(_loc2_ == PetBuffCommand.ACTION_ADD)
         {
            _main.getConnectionManager().getPetAssembly().assembleRemoveBuff(param1);
            _main.getConnectionManager().getPetAssembly().assembleAddBuff(_loc3_,_loc4_);
         }
         else
         {
            _main.getConnectionManager().getPetAssembly().assembleRemoveBuff(param1);
         }
      }
   }
}

