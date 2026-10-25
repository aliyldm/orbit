package net.bigpoint.darkorbit.mvc.gui.windows.warp.model.vo
{
   import net.bigpoint.darkorbit.com.module.ShipWarpModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WarpWindowVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _ships:Vector.<ShipWarpModule>;
      
      private var _isNearSpacestation:Boolean;
      
      public function WarpWindowVO()
      {
         super();
      }
      
      public function get ships() : Vector.<ShipWarpModule>
      {
         return this._ships;
      }
      
      public function set ships(param1:Vector.<ShipWarpModule>) : void
      {
         this._ships = param1;
         this.changed.dispatch();
      }
      
      public function get isNearSpacestation() : Boolean
      {
         return this._isNearSpacestation;
      }
      
      public function set isNearSpacestation(param1:Boolean) : void
      {
         this._isNearSpacestation = param1;
      }
   }
}

