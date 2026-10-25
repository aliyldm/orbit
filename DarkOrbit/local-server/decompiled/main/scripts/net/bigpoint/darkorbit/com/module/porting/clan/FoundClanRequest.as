package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FoundClanRequest implements IModule
   {
      
      private static var _instance:FoundClanRequest;
      
      public var clanTag:String = "";
      
      public var clanDescription:String = "";
      
      public var clanName:String = "";
      
      public function FoundClanRequest(param1:String = "", param2:String = "", param3:String = "")
      {
         super();
         this.clanTag = param2;
         this.clanDescription = param3;
         this.clanName = param1;
      }
      
      public static function get instance() : FoundClanRequest
      {
         return _instance || (_instance = new FoundClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19714;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanTag = param1.readUTF();
         this.clanDescription = param1.readUTF();
         this.clanName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19714);
         param1.writeUTF(this.clanTag);
         param1.writeUTF(this.clanDescription);
         param1.writeUTF(this.clanName);
      }
   }
}

