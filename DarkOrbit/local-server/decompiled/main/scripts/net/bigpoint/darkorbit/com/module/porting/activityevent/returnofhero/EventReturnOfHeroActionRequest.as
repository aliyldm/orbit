package net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventReturnOfHeroActionRequest implements IModule
   {
      
      private static var _instance:EventReturnOfHeroActionRequest;
      
      public static const RETURNOFHEROACTIONTYPE_View:int = 0;
      
      public static const RETURNOFHEROACTIONTYPE_Invited:int = 1;
      
      public static const RETURNOFHEROACTIONTYPE_exchange:int = 2;
      
      public static const RETURNOFHEROACTIONTYPE__MAX:int = 3;
      
      public var actionType:int = 0;
      
      public var exchange:String = "";
      
      public var id:int = 0;
      
      public function EventReturnOfHeroActionRequest(param1:int = 0, param2:int = 0, param3:String = "")
      {
         super();
         this.actionType = param1;
         this.exchange = param3;
         this.id = param2;
      }
      
      public static function get instance() : EventReturnOfHeroActionRequest
      {
         return _instance || (_instance = new EventReturnOfHeroActionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9814;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.actionType = param1.readShort();
         this.exchange = param1.readUTF();
         this.id = param1.readInt();
         this.id = this.id << 12 % 32 | this.id >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9814);
         param1.writeShort(this.actionType);
         param1.writeUTF(this.exchange);
         param1.writeInt(this.id >>> 12 % 32 | this.id << 32 - 12 % 32);
      }
   }
}

