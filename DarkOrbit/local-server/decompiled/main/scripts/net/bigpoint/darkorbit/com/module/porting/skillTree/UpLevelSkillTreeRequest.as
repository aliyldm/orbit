package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpLevelSkillTreeRequest implements IModule
   {
      
      private static var _instance:UpLevelSkillTreeRequest;
      
      public var id:String = "";
      
      public function UpLevelSkillTreeRequest(param1:String = "")
      {
         super();
         this.id = param1;
      }
      
      public static function get instance() : UpLevelSkillTreeRequest
      {
         return _instance || (_instance = new UpLevelSkillTreeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23021;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23021);
         param1.writeUTF(this.id);
      }
   }
}

