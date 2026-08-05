<?php
declare(strict_types=1);
namespace App\Services\Fiscal;
use Config\Fiscal;
use DateTimeImmutable;
use DateTimeZone;
use RuntimeException;
final class FiscalIssueDatePolicy
{
    public function __construct(private ?Fiscal$config=null){}
    public function validate(string$issueDate,?DateTimeImmutable$now=null):void{
        $config=$this->config??config('Fiscal');$zone=new DateTimeZone(config('App')->appTimezone);
        $date=DateTimeImmutable::createFromFormat('!Y-m-d H:i:s',$issueDate,$zone)
            ?:DateTimeImmutable::createFromFormat('!Y-m-d\TH:i',$issueDate,$zone);
        if(!$date)throw new RuntimeException('FISCAL_ISSUE_DATE_INVALID');
        $now=$now?->setTimezone($zone)??new DateTimeImmutable('now',$zone);
        if(!$config->allowFutureIssueDate&&$date>$now)throw new RuntimeException('FISCAL_ISSUE_DATE_FUTURE');
        if($date<$now->modify('-'.$config->maxIssueAgeHours.' hours'))throw new RuntimeException('FISCAL_ISSUE_DATE_TOO_OLD');
    }
}
