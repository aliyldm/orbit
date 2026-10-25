package net.bigpoint.darkorbit.map.view3D.display3D.zones
{
   import away3d.containers.ObjectContainer3D;
   import away3d.materials.ColorMaterial;
   import away3d.materials.MaterialBase;
   import away3d.materials.TextureMaterial;
   import away3d.textures.BitmapTexture;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.errors.IllegalOperationError;
   import flash.geom.ColorTransform;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.POIDesignModule;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.pattern.POIPattern;
   import net.bigpoint.darkorbit.pattern.POITexturePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AbstractZoneView3D extends ObjectContainer3D implements IDisposable
   {
      
      private var _zone:POIZone;
      
      public function AbstractZoneView3D(param1:POIZone)
      {
         var _loc3_:XML = null;
         super();
         this._zone = param1;
         this._zone.zoneTypeSpecification.changed.add(this.redraw);
         this._zone.scaling.changed.add(this.redraw);
         this._zone.rotationSpeed.changed.add(this.redraw);
         this._zone.pulseSpeed.changed.add(this.redraw);
         this._zone.pulseSpeed.changed.add(this.redraw);
         this._zone.movingSpeedX.changed.add(this.redraw);
         this._zone.movingSpeedY.changed.add(this.redraw);
         this.map.mapXmlChanged.add(this.redraw);
         if(this._zone.useCustomShader)
         {
            this._zone.useCustomShader.changed.add(this.redraw);
         }
         Settings.qualityPoizone.changed.add(this.redraw);
         var _loc2_:POIPattern = PatternManager.poizonePatterns[param1.designID];
         if(_loc2_.additionalUberAssetId)
         {
            _loc3_ = UberAssetsLib.instance.getDescriptorByCompositeId(_loc2_.additionalUberAssetId);
            if(_loc3_)
            {
               addChild(new UberAsset3D(_loc3_.display3D[0]));
            }
         }
         this.scale(_loc2_.radiusVisualMultiplier);
         this.redraw();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._zone.zoneTypeSpecification.changed.remove(this.redraw);
         this._zone.scaling.changed.remove(this.redraw);
         this._zone.rotationSpeed.changed.remove(this.redraw);
         this._zone.pulseSpeed.changed.remove(this.redraw);
         this._zone.movingSpeedX.changed.remove(this.redraw);
         this._zone.movingSpeedY.changed.remove(this.redraw);
         this.map.mapXmlChanged.remove(this.redraw);
         if(this._zone.useCustomShader)
         {
            this._zone.useCustomShader.changed.remove(this.redraw);
         }
         Settings.qualityPoizone.changed.remove(this.redraw);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function drawZone(param1:MaterialBase) : void
      {
         throw new IllegalOperationError("Abstract method");
      }
      
      protected function redraw() : void
      {
         var _loc1_:String = POIPattern.DESIGN_TYPE_SIMPLE;
         var _loc2_:POIPattern = PatternManager.poizonePatterns[this._zone.designID];
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.designType;
         }
         switch(_loc1_)
         {
            case POIPattern.DESIGN_TYPE_BACKGROUND:
               if(Settings.qualityPoizone.value < Settings.QUALITY_GOOD)
               {
                  this.drawSimpleView();
               }
               else
               {
                  while(this.numChildren > 0)
                  {
                     this.removeChildAt(0);
                  }
               }
               break;
            case POIPattern.DESIGN_TYPE_TEXTURE:
               if(_loc2_ is POITexturePattern)
               {
                  ResourceManager.fileCollection.load(POITexturePattern(_loc2_).resKey,this.handleTextureLoaded);
               }
               break;
            case POIPattern.DESIGN_TYPE_SIMPLE_IN_LOW:
               if(Settings.qualityPoizone.value <= Settings.QUALITY_LOW)
               {
                  this.drawSimpleView();
               }
               else
               {
                  while(this.numChildren > 0)
                  {
                     this.removeChildAt(0);
                  }
               }
               break;
            default:
               this.drawSimpleView();
         }
      }
      
      private function prepareMaterial(param1:BitmapData) : void
      {
         var _loc3_:MaterialBase = null;
         var _loc2_:POIPattern = PatternManager.poizonePatterns[this._zone.designID];
         if(param1 != null)
         {
            if(Boolean(_loc2_) && _loc2_.useCustomShader)
            {
               _loc3_ = new POIZoneMaterial(new BitmapTexture(param1));
               (_loc3_ as POIZoneMaterial).scaling = this.zone.scaling.value != 0 ? this.zone.scaling.value : _loc2_.textureSize;
               (_loc3_ as POIZoneMaterial).rotationSpeed = this.zone.rotationSpeed.value;
               (_loc3_ as POIZoneMaterial).pulseSpeed = this.zone.pulseSpeed.value;
               (_loc3_ as POIZoneMaterial).movingSpeedX = this.zone.movingSpeedX.value;
               (_loc3_ as POIZoneMaterial).movingSpeedY = this.zone.movingSpeedY.value;
            }
            else
            {
               _loc3_ = new TextureMaterial(new BitmapTexture(param1));
            }
         }
         else
         {
            _loc3_ = new ColorMaterial(POIZoneStyle.getFillColorForZoneType(this.zone),POIZoneStyle.getFillAlphaForZoneType(this.zone));
         }
         _loc3_.blendMode = BlendMode.LAYER;
         this.drawZone(_loc3_);
      }
      
      private function drawSimpleView() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:uint = POIZoneStyle.getMapFillTypeForZoneType(this._zone);
         if(_loc1_ == POIZoneStyle.FILLTYPE_BITMAP)
         {
            _loc2_ = ResourceManager.getBitmapData("simple_patterns",InGameCatalog.getInstance().getPoiDesingSimpleKey(this.zone.designID) || this.zone.zoneType);
            if(this.zone.designID == POIDesignModule.POIDESIGN_SIMPLE_LOW_ONLY)
            {
               _loc3_ = InGameCatalog.getInstance().currentMapPoiColor;
               _loc4_ = (_loc3_ >> 16 & 0xFF) / 255;
               _loc5_ = (_loc3_ >> 8 & 0xFF) / 255;
               _loc6_ = (_loc3_ & 0xFF) / 255;
               _loc7_ = (_loc3_ >> 24 & 0xFF) / 255;
               _loc2_.colorTransform(_loc2_.rect,new ColorTransform(_loc7_,_loc4_,_loc5_,_loc6_));
            }
         }
         this.prepareMaterial(_loc2_);
      }
      
      private function handleTextureLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:String = this._zone.zoneTypeSpecification.value || "image";
         var _loc3_:BitmapData = param1.getEmbeddedBitmapData(_loc2_);
         this.prepareMaterial(_loc3_);
      }
      
      protected function get zone() : POIZone
      {
         return this._zone;
      }
      
      protected function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

