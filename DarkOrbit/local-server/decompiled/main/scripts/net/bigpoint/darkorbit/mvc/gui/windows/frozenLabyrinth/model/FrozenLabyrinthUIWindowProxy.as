package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model
{
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthSynkInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthTimeInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthTopRankerInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class FrozenLabyrinthUIWindowProxy extends SimpleWindowProxy
   {
      
      public function FrozenLabyrinthUIWindowProxy(param1:String)
      {
         super(param1,new FrozenLabyrinthUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : FrozenLabyrinthUIData
      {
         return data as FrozenLabyrinthUIData;
      }
      
      public function updateInfo(param1:FrozenLabyrinthInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateRanking(param1:FrozenLabyrinthRankInfoCommand) : void
      {
         this.viewData.updateRanking(param1);
      }
      
      public function updateTimer(param1:FrozenLabyrinthTimeInfoCommand) : void
      {
         this.viewData.updateTimer(param1);
      }
      
      public function updateTopRankers(param1:FrozenLabyrinthTopRankerInfoCommand) : void
      {
         this.viewData.updateTopRankers(param1);
      }
      
      public function updateKeys(param1:FrozenLabyrinthKeyInfoCommand) : void
      {
         this.viewData.updateKeys(param1);
      }
      
      public function updateSynkLocation(param1:FrozenLabyrinthSynkInfoCommand) : void
      {
         this.viewData.updateSynkLocation(param1);
      }
   }
}

