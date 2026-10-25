package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class UpLevelSkillTreeCommand implements IModule
   {
      
      private static var _instance:UpLevelSkillTreeCommand;
      
      public var id:String = "";
      
      public var researchPoints:int = 0;
      
      public var stack:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public var curLevel:int = 0;
      
      public function UpLevelSkillTreeCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:String = "", param4:int = 0, param5:int = 0)
      {
         super();
         this.id = param3;
         this.researchPoints = param5;
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
         this.success = param1;
         this.curLevel = param4;
      }
      
      public static function get instance() : UpLevelSkillTreeCommand
      {
         return _instance || (_instance = new UpLevelSkillTreeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8333;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 11;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readUTF();
         this.researchPoints = param1.readInt();
         this.researchPoints = this.researchPoints << 12 % 32 | this.researchPoints >>> 32 - 12 % 32;
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
         this.success = param1.readBoolean();
         this.curLevel = param1.readInt();
         this.curLevel = this.curLevel << 10 % 32 | this.curLevel >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8333);
         param1.writeUTF(this.id);
         param1.writeInt(this.researchPoints >>> 12 % 32 | this.researchPoints << 32 - 12 % 32);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
         param1.writeInt(this.curLevel >>> 10 % 32 | this.curLevel << 32 - 10 % 32);
      }
   }
}

