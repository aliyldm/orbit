package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ExpeditionJumpTargetLevelCommand implements IModule
   {
      
      private static var _instance:ExpeditionJumpTargetLevelCommand;
      
      public var result:Boolean = false;
      
      public var stack:BaseStackCommand;
      
      public function ExpeditionJumpTargetLevelCommand(param1:Boolean = false, param2:BaseStackCommand = null)
      {
         super();
         this.result = param1;
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
      }
      
      public static function get instance() : ExpeditionJumpTargetLevelCommand
      {
         return _instance || (_instance = new ExpeditionJumpTargetLevelCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17082;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readBoolean();
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17082);
         param1.writeBoolean(this.result);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

