package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HallOfFamePagesRequest implements IModule
   {
      
      private static var _instance:HallOfFamePagesRequest;
      
      public static const HALLOFFAMEPAGETYPE_Nome:int = 0;
      
      public static const HALLOFFAMEPAGETYPE_TopUser:int = 1;
      
      public static const HALLOFFAMEPAGETYPE_Experience:int = 2;
      
      public static const HALLOFFAMEPAGETYPE_Honor:int = 3;
      
      public static const HALLOFFAMEPAGETYPE__MAX:int = 4;
      
      public var type:int = 0;
      
      public var page:int = 0;
      
      public function HallOfFamePagesRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.type = param2;
         this.page = param1;
      }
      
      public static function get instance() : HallOfFamePagesRequest
      {
         return _instance || (_instance = new HallOfFamePagesRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18768;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
         this.page = param1.readInt();
         this.page = this.page >>> 13 % 32 | this.page << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18768);
         param1.writeShort(this.type);
         param1.writeInt(this.page << 13 % 32 | this.page >>> 32 - 13 % 32);
      }
   }
}

