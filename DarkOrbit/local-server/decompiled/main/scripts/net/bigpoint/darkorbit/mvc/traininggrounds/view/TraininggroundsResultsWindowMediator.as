package net.bigpoint.darkorbit.mvc.traininggrounds.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsResultsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.controller.CreateTraininggroundsResultsWindowCommand;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsResultsDataVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TraininggroundsResultsWindowMediator extends DOAbstractMediator implements IMediator
   {
      
      public static const NAME:String = "TraininggroundsResultsWindowMediator";
      
      public function TraininggroundsResultsWindowMediator(param1:String, param2:Object)
      {
         super(param1,param2);
         mapNotificationToMethod(TraininggroundsResultsWindowNotifications.UPDATE_DATA,this.updateWindowData);
         this.addEventListeners();
      }
      
      private function addEventListeners() : void
      {
         if(!this.view)
         {
            return;
         }
         this.view.addEventListener(TraininggroundsWindowEvent.RESULTS_CLOSED,this.handleResultsWindowClosed);
      }
      
      private function removeEventListeners() : void
      {
         if(!this.view)
         {
            return;
         }
         this.view.removeEventListener(TraininggroundsWindowEvent.RESULTS_CLOSED,this.handleResultsWindowClosed);
      }
      
      private function get view() : TraininggroundsResultsWindow
      {
         return viewComponent as TraininggroundsResultsWindow;
      }
      
      private function updateWindowData(param1:INotification) : void
      {
         var _loc2_:TraininggroundsResultsDataVO = param1.getBody() as TraininggroundsResultsDataVO;
         var _loc3_:Vector.<String> = new Vector.<String>();
         var _loc4_:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
         var _loc5_:Vector.<String> = new Vector.<String>();
         var _loc6_:Vector.<String> = new Vector.<String>();
         _loc5_.push(BPLocale.getItem("label_traininggrounds_results_stats_rounds_won"));
         _loc6_.push(BPLocale.getItem("label_traininggrounds_results_stats_ta_score"));
         if(_loc2_.heroResult == TraininggroundsResultsDataVO.WINNER)
         {
            _loc3_.push(Hero.username,_loc2_.opponentName);
            _loc5_.push(_loc2_.heroRoundsWon.toString());
            _loc5_.push(_loc2_.opponentRoundsWon.toString());
            _loc6_.push(_loc2_.heroTAScore.toString());
            _loc6_.push(_loc2_.opponentTAScore.toString());
         }
         else
         {
            _loc3_.push(_loc2_.opponentName,Hero.username);
            _loc5_.push(_loc2_.opponentRoundsWon.toString());
            _loc5_.push(_loc2_.heroRoundsWon.toString());
            _loc6_.push(_loc2_.opponentTAScore.toString());
            _loc6_.push(_loc2_.heroTAScore.toString());
         }
         _loc4_.push(_loc5_);
         _loc4_.push(_loc6_);
         this.view.updateResultsWindowData(_loc2_.heroResult,_loc3_,_loc4_,_loc2_.rewards);
      }
      
      private function handleResultsWindowClosed(param1:TraininggroundsWindowEvent) : void
      {
         facade.registerCommand(TraininggroundsResultsWindowNotifications.CREATE_WINDOW,CreateTraininggroundsResultsWindowCommand);
         facade.removeMediator(getMediatorName());
         MovieClipUtils.cleanupDisplayObjectContainer(this.view);
      }
      
      override public function onRemove() : void
      {
         this.removeEventListeners();
         super.onRemove();
      }
   }
}

