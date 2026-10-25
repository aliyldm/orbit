package com.bigpoint.utils.bindables
{
   import com.bigpoint.utils.PointLite;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindablePointLite extends PointLite
   {
      
      public static const ZERO:BindablePointLite = new BindablePointLite(0,0,0);
      
      public const changed:ISignal = new Signal();
      
      public function BindablePointLite(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super(param1,param2,param3);
      }
      
      override public function setTo(param1:Number, param2:Number, param3:Number) : void
      {
         if(_x != param1 || _y != param2 || _z != param3)
         {
            _x = param1;
            _y = param2;
            _z = param3;
            this.changed.dispatch();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         if(_x != param1)
         {
            _x = param1;
            this.changed.dispatch();
         }
      }
      
      override public function set y(param1:Number) : void
      {
         if(_y != param1)
         {
            _y = param1;
            this.changed.dispatch();
         }
      }
      
      override public function clone() : PointLite
      {
         return new BindablePointLite(_x,_y,_z);
      }
   }
}

