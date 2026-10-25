package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkillTreeInfoCommand implements IModule
   {
      
      private static var _instance:SkillTreeInfoCommand;
      
      public var id:String = "";
      
      public var curLevel:int = 0;
      
      public function SkillTreeInfoCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.id = param1;
         this.curLevel = param2;
      }
      
      public static function get instance() : SkillTreeInfoCommand
      {
         return _instance || (_instance = new SkillTreeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17396;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readUTF();
         this.curLevel = param1.readInt();
         this.curLevel = this.curLevel << 6 % 32 | this.curLevel >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17396);
         param1.writeUTF(this.id);
         param1.writeInt(this.curLevel >>> 6 % 32 | this.curLevel << 32 - 6 % 32);
      }
   }
}

