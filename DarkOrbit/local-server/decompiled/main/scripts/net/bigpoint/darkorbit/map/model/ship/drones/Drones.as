package net.bigpoint.darkorbit.map.model.ship.drones
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.bigpoint.utils.bindables.BindableString;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Drones
   {
      
      public const dronesListChanged:ISignal = new Signal();
      
      public const droneFormationId:BindableInt = new BindableInt(0);
      
      public const userScale:BindableNumber = new BindableNumber(1);
      
      public const visible:BindableBoolean = new BindableBoolean(true);
      
      public const simpleDroneRepresentation:BindableString = new BindableString("");
      
      private var _drones:Vector.<Drone> = new Vector.<Drone>();
      
      public function Drones()
      {
         super();
      }
      
      public function get drones() : Vector.<Drone>
      {
         return this._drones;
      }
      
      public function set drones(param1:Vector.<Drone>) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Drone = null;
         var _loc9_:Number = NaN;
         if(this._drones.length == param1.length)
         {
            _loc6_ = true;
            _loc7_ = 0;
            while(_loc7_ < param1.length)
            {
               if(!param1[_loc7_].equals(this._drones[_loc7_]))
               {
                  _loc6_ = false;
                  break;
               }
               _loc7_++;
            }
            if(_loc6_)
            {
               return;
            }
         }
         var _loc2_:Boolean = this._drones.length != param1.length;
         var _loc3_:String = "";
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc8_ = param1[_loc5_];
            _loc3_ += _loc8_.simpleRepresentation;
            _loc4_ += _loc8_.level;
            if(!_loc2_ && !_loc8_.visualyEquals(this._drones[_loc5_]))
            {
               _loc2_ = true;
            }
            _loc5_++;
         }
         if(_loc3_.length)
         {
            _loc3_ += "<font color=\"#dddddd\">";
            _loc9_ = _loc4_ / Number(param1.length);
            _loc3_ += " [" + int(_loc9_).toString();
            if(_loc9_ % 1 != 0)
            {
               _loc3_ += "." + Math.round(10 * (_loc9_ % 1));
            }
            _loc3_ += "]</font>";
         }
         this._drones = param1.concat();
         this.simpleDroneRepresentation.value = _loc3_;
         if(_loc2_)
         {
            this.dronesListChanged.dispatch();
         }
      }
   }
}

