package net.bigpoint.darkorbit.map.view2D.display.uber
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import flash.display.Shape;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class UberPivot2D extends Shape implements IUpdatable
   {
      
      private var _pivot:BindablePointLite;
      
      public function UberPivot2D(param1:BindablePointLite)
      {
         super();
         this._pivot = param1;
      }
      
      public function updateObj(param1:Number) : void
      {
         this._pivot.setTo(x,y,0);
      }
   }
}

