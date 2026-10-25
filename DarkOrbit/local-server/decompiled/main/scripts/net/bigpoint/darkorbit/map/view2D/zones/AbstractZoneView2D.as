package net.bigpoint.darkorbit.map.view2D.zones
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.geom.ColorTransform;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.POIDesignModule;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneStyle;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.pattern.POIPattern;
   import net.bigpoint.darkorbit.pattern.POITexturePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class AbstractZoneView2D extends Sprite implements ILayerChild, IDisposable
   {
      
      private var _zone:POIZone;
      
      public function AbstractZoneView2D(param1:POIZone)
      {
         var _loc3_:XML = null;
         super();
         this._zone = param1;
         this._zone.zoneTypeSpecification.changed.add(this.redraw);
         Settings.qualityPoizone.changed.add(this.redraw);
         this.map.mapXmlChanged.add(this.redraw);
         this.redraw();
         var _loc2_:POIPattern = PatternManager.poizonePatterns[param1.designID];
         if(_loc2_.additionalUberAssetId)
         {
            _loc3_ = UberAssetsLib.instance.getDescriptorByCompositeId(_loc2_.additionalUberAssetId);
            if(_loc3_)
            {
               addChild(new UberAsset2D(_loc3_.display2D[0]));
            }
         }
         this.scaleX = this.scaleY = _loc2_.radiusVisualMultiplier;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.zone.zoneTypeSpecification.changed.remove(this.redraw);
         Settings.qualityPoizone.changed.remove(this.redraw);
         this.map.mapXmlChanged.add(this.redraw);
         graphics.clear();
         MovieClipUtils.cleanupDisplayObjectContainer(this);
         MovieClipUtils.removeDisplayObject(this);
      }
      
      public function get layer() : int
      {
         return -1;
      }
      
      protected function drawZone(param1:uint, param2:BitmapData, param3:Boolean) : void
      {
         throw new IllegalOperationError("Abstract method");
      }
      
      protected function redraw() : void
      {
         graphics.clear();
         var _loc1_:String = POIPattern.DESIGN_TYPE_SIMPLE;
         var _loc2_:POIPattern = PatternManager.poizonePatterns[this.zone.designID];
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.designType;
         }
         switch(_loc1_)
         {
            case POIPattern.DESIGN_TYPE_BACKGROUND:
               if(Settings.qualityPoizone.value <= Settings.QUALITY_LOW || Settings.gpuSupport == false)
               {
                  this.drawSimpleView();
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
               break;
            default:
               this.drawSimpleView();
         }
      }
      
      public function get zone() : POIZone
      {
         return this._zone as POIZone;
      }
      
      protected function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      protected function round(param1:Number) : int
      {
         return Math.round(param1);
      }
      
      private function drawSimpleView() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:uint = POIZoneStyle.getMapFillTypeForZoneType(this.zone);
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
         this.drawZone(_loc1_,_loc2_,true);
      }
      
      private function handleTextureLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:POITexturePattern = PatternManager.poizonePatterns[this.zone.designID] as POITexturePattern;
         var _loc3_:String = this.zone.zoneTypeSpecification.value || "image";
         if(param1.hasEmbeddedObject(_loc3_))
         {
            this.drawZone(POIZoneStyle.FILLTYPE_BITMAP,param1.getEmbeddedBitmapData(_loc3_),_loc2_.repeat);
         }
      }
   }
}

