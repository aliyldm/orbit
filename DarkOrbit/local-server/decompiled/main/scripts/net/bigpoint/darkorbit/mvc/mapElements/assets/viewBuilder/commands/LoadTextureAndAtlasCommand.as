package net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.commands
{
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.ViewCreateDTO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadTextureAndAtlasCommand extends AsyncCommand
   {
      
      public function LoadTextureAndAtlasCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ViewCreateDTO = param1.getBody() as ViewCreateDTO;
         var _loc3_:DOTexturesProxy = facade.retrieveProxy(DOTexturesProxy.NAME) as DOTexturesProxy;
         _loc3_.getTextureResources(_loc2_.textureResources).addOnce(this.handleTextureAtlasLoaded);
      }
      
      private function handleTextureAtlasLoaded() : void
      {
         commandComplete();
      }
   }
}

