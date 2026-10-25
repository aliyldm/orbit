package net.bigpoint.darkorbit.mvc.events.control
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MoodAssetDestributionEvent;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandelMoodAssetsDestributionCommand extends DOAbstractSimpleCommand
   {
      
      public function HandelMoodAssetsDestributionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:MoodAssetDestributionEvent = param1.getBody() as MoodAssetDestributionEvent;
         if(_loc2_.isActive)
         {
            assetsProxy.loadAndCall(_loc2_.definitionResKey,this.handleLoaded,[_loc2_]);
         }
      }
      
      private function handleLoaded(param1:MoodAssetDestributionEvent) : void
      {
         var _loc3_:Vector.<SpringFightMapAssetCreateVo> = null;
         var _loc4_:SpringFightMapAssetCreateVo = null;
         var _loc2_:XMLFinisher = assetsProxy.getLib(param1.definitionResKey) as XMLFinisher;
         if(_loc2_)
         {
            _loc3_ = this.getMapAssetCreateVos(_loc2_.getXML(),param1.types);
            for each(_loc4_ in _loc3_)
            {
               this.buildMapAsset(_loc4_);
            }
         }
      }
      
      private function buildMapAsset(param1:SpringFightMapAssetCreateVo) : void
      {
         var _loc2_:MapEntity = new MapEntity(Map.NEXT_FREE_ID,param1.pointLite);
         _loc2_.addTrait(new UberBackgroundDisplayTrait(param1.pfac,param1.layer,param1.xmlResKey,UberAssetsLib.instance.getDescriptor(param1.xmlResKey,UberAssetsLib.LIB_DEFAULT)));
         screenManager.map.addEntity(_loc2_);
      }
      
      private function getMapAssetCreateVos(param1:XML, param2:Vector.<String>) : Vector.<SpringFightMapAssetCreateVo>
      {
         var _loc3_:Vector.<SpringFightMapAssetCreateVo> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc10_:XMLList = null;
         var _loc11_:XML = null;
         var _loc12_:XML = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:PointLite = null;
         var _loc16_:XML = null;
         _loc3_ = new Vector.<SpringFightMapAssetCreateVo>();
         var _loc4_:int = screenManager.map ? screenManager.map.getMapID() : Settings.mapID;
         var _loc8_:int = int(param2.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = param2[_loc9_];
            _loc10_ = param1.child("map");
            for each(_loc11_ in _loc10_)
            {
               if(int(_loc11_.attribute("id")) == _loc4_)
               {
                  for each(_loc12_ in _loc11_.child("layer"))
                  {
                     if(String(_loc12_.attribute("id")) == _loc7_)
                     {
                        _loc5_ = int(_loc12_.attribute("pfac"));
                        _loc6_ = int(_loc12_.attribute("index"));
                        _loc10_ = param1.child("asset");
                        _loc13_ = screenManager.map ? screenManager.map.serious_width : Map.STD_WIDTH;
                        _loc14_ = screenManager.map ? screenManager.map.serious_height : Map.STD_HEIGHT;
                        for each(_loc16_ in _loc10_)
                        {
                           if(String(_loc16_.attribute("id")) == _loc7_)
                           {
                              _loc15_ = ParserUtility.parsePointLiteNumbers(_loc16_);
                              _loc15_.x *= _loc13_;
                              _loc15_.y *= _loc14_;
                              _loc3_.push(new SpringFightMapAssetCreateVo(String(_loc16_.attribute("xmlResKey")),_loc15_,_loc5_,_loc6_));
                           }
                        }
                     }
                  }
               }
            }
            _loc9_++;
         }
         return _loc3_;
      }
   }
}

import com.bigpoint.utils.PointLite;

class SpringFightMapAssetCreateVo
{
   
   private var _xmlResKey:String;
   
   private var _pointLite:PointLite;
   
   private var _pfac:int;
   
   private var _layer:int;
   
   public function SpringFightMapAssetCreateVo(param1:String, param2:PointLite, param3:int, param4:int)
   {
      super();
      this._layer = param4;
      this._pfac = param3;
      this._pointLite = param2;
      this._xmlResKey = param1;
   }
   
   public function get xmlResKey() : String
   {
      return this._xmlResKey;
   }
   
   public function get pointLite() : PointLite
   {
      return this._pointLite;
   }
   
   public function get pfac() : int
   {
      return this._pfac;
   }
   
   public function get layer() : int
   {
      return this._layer;
   }
}
