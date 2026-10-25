package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.TraininggroundsWindow;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.TraininggroundsWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateTraininggroundsWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CreateTraininggroundsWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeCommand(TraininggroundsWindowNotifications.CREATE_WINDOW);
         this.loadAndBuildWindow();
      }
      
      private function loadAndBuildWindow() : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,["traininggrounds_baseWindow",this.handleContentXMLLoaded]);
      }
      
      public function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:SimpleWindow = this.createSimpleWindow();
         var _loc3_:TraininggroundsWindow = new TraininggroundsWindow(_loc2_);
         _loc2_.getRootContainer().addChild(_loc3_);
         var _loc4_:XML = param1.getXML();
         UISystem.getInstance().loadAndBuild(_loc4_,_loc3_,this.handleWindowContentCreated,[_loc3_]);
      }
      
      private function handleWindowContentCreated(param1:TraininggroundsWindow) : void
      {
         if(retrieveMediator(TraininggroundsWindowMediator.NAME) != null)
         {
            throw new Error("tried to create another TraininggroundsWindow");
         }
         param1.handleWindowContentCreated();
         registerMediator(new TraininggroundsWindowMediator(TraininggroundsWindowMediator.NAME,param1));
         facade.sendNotification(TraininggroundsWindowNotifications.REPROCESS_CACHED_DATA);
      }
      
      protected function createSimpleWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = guiManager.getWindow(GuiConstants.TRAINING_GROUNDS_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = guiManager.createWindow(GuiConstants.TRAINING_GROUNDS_WINDOW) as SimpleWindow;
         }
         return _loc1_;
      }
   }
}

