package net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.commands
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.ViewCreateDTO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadMapAssetXMLCommand extends AsyncCommand
   {
      
      private var _dto:ViewCreateDTO;
      
      public function LoadMapAssetXMLCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:FileCollectionFinisher = null;
         super.execute(param1);
         this._dto = param1.getBody() as ViewCreateDTO;
         if(this._dto.xmlData)
         {
            commandComplete();
         }
         else
         {
            if(this._dto.clearCache)
            {
               _loc2_ = ResourceManager.fileCollection.getFinisher(this._dto.xml);
               if(_loc2_)
               {
                  _loc2_.dispose();
               }
            }
            sendNotification(AssetNotifications.LOAD_ASSET,[this._dto.xml,this.handleXMLLoaded]);
         }
      }
      
      private function handleXMLLoaded(param1:XMLFinisher) : void
      {
         this._dto.xmlData = param1.getXML();
         if(this._dto.xmlData == null)
         {
            this._dto.xmlData = new XML();
         }
         commandComplete();
      }
   }
}

