package net.bigpoint.darkorbit.map.view2D.display.uber
{
   import net.bigpoint.darkorbit.map.common.animation.UberAnimationBase;
   
   public class UberAnimation2D extends UberAnimationBase
   {
      
      public function UberAnimation2D(param1:String, param2:XML, param3:UberAsset2D)
      {
         super(param1,param2,param3.getViewElement);
      }
   }
}

