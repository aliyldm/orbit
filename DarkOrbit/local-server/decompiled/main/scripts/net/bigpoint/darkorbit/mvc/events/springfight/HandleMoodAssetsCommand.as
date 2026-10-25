package net.bigpoint.darkorbit.mvc.events.springfight
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MoodAssetEvent;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleMoodAssetsCommand extends DOAbstractAsyncCommand
   {
      
      public function HandleMoodAssetsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:MoodAssetEvent = param1.getBody() as MoodAssetEvent;
         if(_loc2_.isActive)
         {
            sendNotification(AssetNotifications.LOAD_ASSET,[_loc2_.definitionResKey,this.handleLoaded]);
         }
      }
      
      private function handleLoaded(param1:FileCollectionFinisher) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:XML = null;
         var _loc5_:MapEntity = null;
         if(param1 is XMLFinisher)
         {
            _loc2_ = (param1 as XMLFinisher).getXML().child("info");
            _loc3_ = screenManager.map ? screenManager.map.getMapID() : Settings.mapID;
            for each(_loc4_ in _loc2_)
            {
               if(int(_loc4_.attribute("mapId")) == _loc3_)
               {
                  _loc5_ = new MapEntity(Map.NEXT_FREE_ID,new PointLite(int(_loc4_.attribute("_x")),int(_loc4_.attribute("_y"))));
                  _loc5_.addTrait(new UberBackgroundDisplayTrait(int(_loc4_.attribute("pfac")),int(_loc4_.attribute("layer")),String(_loc4_.attribute("xmlResKey")),UberAssetsLib.instance.getDescriptor(String(_loc4_.attribute("xmlResKey")),UberAssetsLib.LIB_DEFAULT)));
                  screenManager.map.addEntity(_loc5_);
               }
            }
         }
      }
   }
}

