package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.StringPair;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.JumpRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Portal extends MapEntity
   {
      
      public static const TYPE_HIGH_SCORE_GATE:int = 14;
      
      public const jumped:ISignal = new Signal(Number);
      
      public const text:StringPair = new StringPair();
      
      private const delayBetweenClick:Number = 5;
      
      protected var isClicked:Boolean = false;
      
      protected var isJumping:Boolean = false;
      
      private var _designId:int;
      
      public function Portal(param1:int, param2:PointLite, param3:int, param4:Boolean = true, param5:Boolean = true)
      {
         super(param1,param2);
         this._designId = param3;
         UberAssetsLib.instance.fillTraits(this,param3.toString(),UberAssetsLib.LIB_PORTALS,this.handleIconClicked);
         if(!param5)
         {
            removeTraitByType(AbstractMiniMapTrait);
         }
      }
      
      public function get designId() : int
      {
         return this._designId;
      }
      
      public function jump(param1:Number = 0) : void
      {
         this.jumped.dispatch(param1);
         this.isJumping = true;
         setTimeout(this.resetIsJumping,param1 * 1000);
      }
      
      protected function handleIconClicked() : void
      {
         if(this.isClicked || this.isJumping)
         {
            return;
         }
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new JumpRequest());
         this.isClicked = true;
         setTimeout(this.resetIsClicked,this.delayBetweenClick * 1000);
      }
      
      private function resetIsJumping() : void
      {
         this.isJumping = false;
      }
      
      private function resetIsClicked() : void
      {
         this.isClicked = false;
      }
   }
}

