package net.bigpoint.darkorbit.mvc.events.christmastreeevent
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.ChristmasTreeEvent;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleChristmasTreesCommand extends DOAbstractSimpleCommand
   {
      
      public function HandleChristmasTreesCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ChristmasTreeEvent = param1.getBody() as ChristmasTreeEvent;
         if(_loc2_.isActive)
         {
            this.activate();
         }
         else
         {
            this.deactivate();
         }
      }
      
      private function activate(param1:int = 0) : void
      {
         var _loc7_:PointLite = null;
         var _loc9_:MapEntity = null;
         var _loc2_:Map = ScreenManager.getInstance().map;
         if(_loc2_ == null)
         {
            if(param1 < 4)
            {
               TweenMax.delayedCall(5,this.activate,[param1 + 1]);
            }
            return;
         }
         var _loc3_:int = _loc2_.getMapID();
         var _loc4_:int = _loc2_.serious_width * 0.9;
         var _loc5_:int = _loc2_.serious_height * 0.9;
         var _loc6_:int = 5;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = new PointLite(FastMath.getRandomBySeed(_loc3_ * (_loc8_ + _loc3_) * _loc5_) * _loc4_,FastMath.getRandomBySeed(_loc3_ * (_loc8_ + _loc3_) * _loc4_) * _loc5_);
            _loc9_ = new MapEntity(Map.NEXT_FREE_ID,_loc7_);
            UberAssetsLib.instance.fillTraits(_loc9_,"christmasTreeAsteroid",UberAssetsLib.LIB_DEFAULT);
            screenManager.map.addEntity(_loc9_);
            _loc8_++;
         }
      }
      
      private function deactivate() : void
      {
      }
   }
}

