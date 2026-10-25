package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsResultsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.TraininggroundsResultsWindow;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.TraininggroundsResultsWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateTraininggroundsResultsWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CreateTraininggroundsResultsWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = guiManager.getWindow(GuiConstants.TRAINING_GROUNDS_RESULTS_WINDOW);
         if(_loc2_ == null)
         {
            this.loadAndBuildWindow();
         }
         else if(!_loc2_.maximized)
         {
            _loc2_.maximize();
         }
      }
      
      private function loadAndBuildWindow() : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,["traininggrounds_resultsWindow",this.handleContentXMLLoaded]);
      }
      
      public function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:SimpleWindow = this.createSimpleWindow();
         var _loc3_:TraininggroundsResultsWindow = new TraininggroundsResultsWindow(_loc2_);
         _loc2_.getRootContainer().addChild(_loc3_);
         var _loc4_:XML = param1.getXML();
         UISystem.getInstance().loadAndBuild(_loc4_,_loc3_,this.handleWindowContentCreated,[_loc3_]);
      }
      
      private function handleWindowContentCreated(param1:TraininggroundsResultsWindow) : void
      {
         param1.handleWindowContentCreated();
         registerMediator(new TraininggroundsResultsWindowMediator(TraininggroundsResultsWindowMediator.NAME,param1));
         facade.sendNotification(TraininggroundsResultsWindowNotifications.REPROCESS_CACHED_DATA);
      }
      
      protected function createSimpleWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = guiManager.createWindow(GuiConstants.TRAINING_GROUNDS_RESULTS_WINDOW) as SimpleWindow;
         _loc1_.maximize();
         return _loc1_;
      }
   }
}

