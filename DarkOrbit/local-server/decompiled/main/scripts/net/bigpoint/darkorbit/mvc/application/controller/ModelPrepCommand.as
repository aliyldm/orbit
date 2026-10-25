package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.application.model.ProfileProxy;
   import net.bigpoint.darkorbit.mvc.application.model.SystemManagerProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.MapManagerProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UnloadFinisherProxy;
   import net.bigpoint.darkorbit.mvc.common.model.javaScript.JavaScriptDelayedCallsProxy;
   import net.bigpoint.darkorbit.mvc.common.model.pattern.proxy.PatternManagerProxy;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.proxy.CompanyHierarchyProxy;
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import net.bigpoint.darkorbit.mvc.hints.model.HintsProxy;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventProxy;
   import net.bigpoint.darkorbit.mvc.spaceMap.SpaceMapDataProxy;
   import net.bigpoint.darkorbit.mvc.stats.model.StatsProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ModelPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function ModelPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new ConnectionProxy());
         facade.registerProxy(new PatternManagerProxy());
         facade.registerProxy(new AssetsProxy());
         facade.registerProxy(new UnloadFinisherProxy(new Vector.<FileCollectionFinisher>()));
         facade.registerProxy(new StatsProxy());
         facade.registerProxy(new DOTexturesProxy());
         facade.registerProxy(new BattleStationProxy());
         facade.registerProxy(new CompanyHierarchyProxy());
         facade.registerProxy(new SpaceMapDataProxy());
         facade.registerProxy(new SectorControlProxy());
         facade.registerProxy(new ServerEventProxy());
         facade.registerProxy(new ProfileProxy());
         facade.registerProxy(new MapManagerProxy());
         facade.registerProxy(new SystemManagerProxy());
         facade.registerProxy(new HintsProxy());
         facade.registerProxy(new JavaScriptDelayedCallsProxy(new Vector.<INotification>()));
      }
   }
}

