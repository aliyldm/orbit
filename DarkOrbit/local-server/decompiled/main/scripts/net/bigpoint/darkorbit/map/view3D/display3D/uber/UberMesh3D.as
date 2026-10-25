package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.materials.methods.EffectMethodBase;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.PrefabView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   
   public class UberMesh3D extends UberContainer3D implements IDisposable
   {
      
      private var _loaderClass:Class;
      
      public var faction:BindableString;
      
      private var _mesh:PrefabView3D;
      
      private var _alpha:Number = 1;
      
      public function UberMesh3D(param1:XML, param2:BindableString = null, param3:Class = null)
      {
         this._loaderClass = param3 || ShipView3D;
         if(param1.attribute("faction").length() > 0)
         {
            this.faction = new BindableString(String(param1.@faction));
            this.faction.changed.add(this.applyFactionVisibility);
         }
         super(param1,param2);
      }
      
      public function get mesh() : PrefabView3D
      {
         return this._mesh;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
         if(this._mesh)
         {
            this._mesh.alpha = param1;
         }
      }
      
      public function get glow() : Number
      {
         return this._mesh ? Number(this._mesh.shaderParams.glow) : 0;
      }
      
      public function set glow(param1:Number) : void
      {
         if(this._mesh)
         {
            this._mesh.shaderParams.glow = param1;
         }
      }
      
      override protected function loadView() : void
      {
         this._mesh = new this._loaderClass(_descriptor);
         this._mesh.name = "content";
         this._mesh.alpha = this._alpha;
         addChild(this._mesh);
         if(this._mesh.numChildren > 0)
         {
            this.applyFactionVisibility();
            setTimeout(ready.dispatch,1);
         }
         else
         {
            this._mesh.changed.add(this.handleViewLoadComplete);
         }
         this._mesh.zOffset = int(Number(String(_descriptor.@zOffset))) || 0;
      }
      
      override protected function unloadView() : void
      {
         if(this._mesh)
         {
            removeChild(this._mesh);
            this._mesh.dispose();
            this._mesh.changed.remove(this.handleViewLoadComplete);
            this._mesh = null;
         }
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         if(this._mesh)
         {
            this._mesh.addMethod(param1);
         }
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         if(this._mesh)
         {
            this._mesh.removeMethod(param1);
         }
      }
      
      public function removeAllMethods() : void
      {
         if(this._mesh)
         {
            this._mesh.removeAllMethods();
         }
      }
      
      private function applyFactionVisibility() : void
      {
         var _loc1_:* = 0;
         if(this.faction)
         {
            _loc1_ = int(this._mesh.numChildren - 1);
            while(_loc1_ >= 0)
            {
               if(this._mesh.getChildAt(_loc1_).name == "eic" && this.faction.value != "eic" || this._mesh.getChildAt(_loc1_).name == "vru" && this.faction.value != "vru" || this._mesh.getChildAt(_loc1_).name == "mmo" && this.faction.value != "mmo")
               {
                  this._mesh.removeChildAt(_loc1_);
               }
               _loc1_--;
            }
         }
      }
      
      private function handleViewLoadComplete() : void
      {
         this._mesh.changed.remove(this.handleViewLoadComplete);
         this.applyFactionVisibility();
         setTimeout(ready.dispatch,1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.faction)
         {
            this.faction.changed.remove(this.applyFactionVisibility);
         }
         super.disposeView(param1);
      }
   }
}

