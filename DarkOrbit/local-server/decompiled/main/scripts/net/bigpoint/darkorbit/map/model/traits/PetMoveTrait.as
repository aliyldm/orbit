package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   
   public class PetMoveTrait extends MoveTrait
   {
      
      public function PetMoveTrait()
      {
         super();
      }
      
      override public function goto(param1:int, param2:int, param3:Function = null, param4:Array = null, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc9_:int = 0;
         var _loc7_:int = param1;
         var _loc8_:int = param2;
         if((owner as Pet).evasionProtocolEquiped)
         {
            _loc9_ = 150;
            _loc7_ = (Math.random() - 0.5) * _loc9_ + param1;
            _loc8_ = (Math.random() - 0.5) * _loc9_ + param2;
         }
         super.goto(_loc7_,_loc8_,this.goto,[param1,param2,null,null,param5],param5 * 2,param6);
      }
   }
}

