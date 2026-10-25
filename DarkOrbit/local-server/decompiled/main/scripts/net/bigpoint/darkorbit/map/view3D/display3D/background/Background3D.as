package net.bigpoint.darkorbit.map.view3D.display3D.background
{
   import away3d.containers.ObjectContainer3D;
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.lensflares.ILensFlaresProvider;
   import net.bigpoint.darkorbit.map.common.lensflares.LensFlareVO;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class Background3D extends ObjectContainer3D implements ILensFlaresProvider
   {
      
      private var _backgroundScene:UberAsset3D;
      
      private var _backgroundColor:uint = 0;
      
      private var _mapView:IMapView;
      
      private var _uberDisplayList:EntityTraitContainer;
      
      private var _data2view:Dictionary = new Dictionary(true);
      
      private var _map:Map;
      
      private var _lensFlares:Vector.<LensFlareVO> = new Vector.<LensFlareVO>();
      
      public function Background3D(param1:IMapView)
      {
         super();
         this._mapView = param1;
      }
      
      public function set map(param1:Map) : void
      {
         if(this._map)
         {
            this._map.mapXmlChanged.remove(this.reload);
            this._uberDisplayList.traitAdded.remove(this.handleUberDisplayTraitAdded);
            this._uberDisplayList.traitRemoved.remove(this.handleUberDisplayTraitRemoved);
         }
         this._map = param1;
         if(this._map)
         {
            this._map.mapXmlChanged.add(this.reload);
            this._uberDisplayList = this._map.getTraitsList(UberBackgroundDisplayTrait);
            this._uberDisplayList.traitAdded.add(this.handleUberDisplayTraitAdded);
            this._uberDisplayList.traitRemoved.add(this.handleUberDisplayTraitRemoved);
         }
         this.reload();
      }
      
      public function get lensFlares() : Vector.<LensFlareVO>
      {
         return this._lensFlares;
      }
      
      private function handleUberDisplayTraitAdded(param1:UberBackgroundDisplayTrait) : void
      {
         var _loc2_:XML = null;
         var _loc3_:UberAsset3D = null;
         if(!this.isAvailableForCurrentMap)
         {
            return;
         }
         if(Boolean(param1.descriptor) && param1.descriptor.background3D.length() > 0)
         {
            _loc2_ = param1.descriptor.background3D[0];
            _loc3_ = new UberAsset3D(_loc2_);
            _loc3_.x = param1.owner.x3D;
            _loc3_.y = -param1.parallaxFactor * 100;
            _loc3_.z = param1.owner.z3D;
            addChild(_loc3_);
            this._data2view[param1] = _loc3_;
         }
      }
      
      private function handleUberDisplayTraitRemoved(param1:UberBackgroundDisplayTrait) : void
      {
         var _loc2_:UberAsset3D = this._data2view[param1];
         if(_loc2_)
         {
            removeChild(_loc2_);
            _loc2_.dispose();
            this._data2view[param1] = null;
            delete this._data2view[param1];
         }
      }
      
      public function calculateScreenPosition(param1:LensFlareVO, param2:PointLite) : void
      {
         this._mapView.game2screen(param1.worldPosition.x,param1.worldPosition.y,param1.worldPosition.z,param2);
      }
      
      public function get isAvailableForCurrentMap() : Boolean
      {
         return this._backgroundScene != null;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      private function reload() : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         if(this._backgroundScene)
         {
            this._backgroundScene.disposeView(true);
            this._backgroundScene = null;
            this._backgroundColor = 0;
         }
         this._lensFlares.length = 0;
         var _loc1_:XML = UberAssetsLib.instance.getDescriptor(String(this._map.mapXml.display3D.@templateId),UberAssetsLib.LIB_MAPS);
         if(Boolean(this._map) && this._map.mapXml.display3D.length() > 0)
         {
            if(_loc1_)
            {
               this._backgroundScene = new UberAsset3D(_loc1_.display3D[0]);
               addChild(this._backgroundScene);
               _loc2_ = _loc1_.display3D[0].lensFlare;
               for each(_loc3_ in _loc2_)
               {
                  this._lensFlares.push(new LensFlareVO(int(_loc3_.attribute("id")),int(_loc3_.attribute("typeID")),new PointLite(Number(_loc3_.attribute("x")),-Number(_loc3_.attribute("z")),-Number(_loc3_.attribute("y"))),ParserUtility.parseBooleanFromString(_loc3_.attribute("star")),String(_loc3_.attribute("blendMode"))));
               }
            }
         }
         this._backgroundColor = uint("0x" + this._map.mapXml.@backgroundColor);
      }
   }
}

