package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SkylabViewModuleBackCommand implements IModule
   {
      
      private static var _instance:SkylabViewModuleBackCommand;
      
      public var collectorInfo:SkylabCollectorInfoCommand;
      
      public var upgrade:SkylabModuleUpgradeCommand;
      
      public var productivity:SkylabModuleProductivityCommand;
      
      public var xenoInfo:SkylabXenoInfoCommand;
      
      public var strorageInfo:SkylabStorageInfoCommand;
      
      public var moduleName:String = "";
      
      public function SkylabViewModuleBackCommand(param1:String = "", param2:SkylabModuleUpgradeCommand = null, param3:SkylabModuleProductivityCommand = null, param4:SkylabCollectorInfoCommand = null, param5:SkylabStorageInfoCommand = null, param6:SkylabXenoInfoCommand = null)
      {
         super();
         if(param4 == null)
         {
            this.collectorInfo = new SkylabCollectorInfoCommand();
         }
         else
         {
            this.collectorInfo = param4;
         }
         if(param2 == null)
         {
            this.upgrade = new SkylabModuleUpgradeCommand();
         }
         else
         {
            this.upgrade = param2;
         }
         if(param3 == null)
         {
            this.productivity = new SkylabModuleProductivityCommand();
         }
         else
         {
            this.productivity = param3;
         }
         if(param6 == null)
         {
            this.xenoInfo = new SkylabXenoInfoCommand();
         }
         else
         {
            this.xenoInfo = param6;
         }
         if(param5 == null)
         {
            this.strorageInfo = new SkylabStorageInfoCommand();
         }
         else
         {
            this.strorageInfo = param5;
         }
         this.moduleName = param1;
      }
      
      public static function get instance() : SkylabViewModuleBackCommand
      {
         return _instance || (_instance = new SkylabViewModuleBackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1858;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.collectorInfo = SkylabCollectorInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.collectorInfo)
         {
            this.collectorInfo.read(param1);
         }
         this.upgrade = SkylabModuleUpgradeCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.upgrade)
         {
            this.upgrade.read(param1);
         }
         this.productivity = SkylabModuleProductivityCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.productivity)
         {
            this.productivity.read(param1);
         }
         this.xenoInfo = SkylabXenoInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.xenoInfo)
         {
            this.xenoInfo.read(param1);
         }
         this.strorageInfo = SkylabStorageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.strorageInfo)
         {
            this.strorageInfo.read(param1);
         }
         this.moduleName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1858);
         if(null != this.collectorInfo)
         {
            this.collectorInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.upgrade)
         {
            this.upgrade.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.productivity)
         {
            this.productivity.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.xenoInfo)
         {
            this.xenoInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.strorageInfo)
         {
            this.strorageInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.moduleName);
      }
   }
}

