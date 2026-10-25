package net.bigpoint.darkorbit.map.view3D.display3D.prefab
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   
   public class ShipView3D extends PrefabView3D
   {
      
      public const enginesSlots:Vector.<Slot3D> = new Vector.<Slot3D>();
      
      public const laserSlots:Vector.<Slot3D> = new Vector.<Slot3D>();
      
      public const dockingPoints:Vector.<Slot3D> = new Vector.<Slot3D>();
      
      private var _lasersSlots:Object = {};
      
      public function ShipView3D(param1:XML)
      {
         super(param1);
      }
      
      override public function set geometry(param1:ObjectContainer3D) : void
      {
         this.enginesSlots.length = 0;
         this._lasersSlots = {};
         super.geometry = param1;
         changed.dispatch();
      }
      
      public function get lasersSlots() : Object
      {
         return this._lasersSlots;
      }
      
      override protected function processMesh(param1:Mesh) : void
      {
         var _loc2_:Slot3D = null;
         if(param1.name.indexOf("engine_") != -1)
         {
            this.enginesSlots.push(Slot3D.fromMesh(param1));
         }
         else if(param1.name.indexOf("laserpoint_") != -1)
         {
            _loc2_ = Slot3D.fromMesh(param1);
            this._lasersSlots[param1.name.slice("laserpoint_".length)] = _loc2_;
            this.laserSlots.push(_loc2_);
         }
         else if(param1.name.indexOf("light_laser") == -1)
         {
            if(param1.name.indexOf("light_position") == -1)
            {
               if(param1.name.indexOf("rocketlauncher") == -1)
               {
                  if(param1.name.indexOf("dockingPoint_") != -1)
                  {
                     this.dockingPoints.push(Slot3D.fromMesh(param1));
                  }
                  else
                  {
                     super.processMesh(param1);
                  }
               }
            }
         }
      }
      
      public function getLaserSlot(param1:String) : Slot3D
      {
         return this._lasersSlots[param1];
      }
   }
}

