'use strict';
const assert = require('node:assert/strict');
const create = require('../../assets/js/proposal_editor_save.js');
const deferred = () => { let resolve, reject; const promise = new Promise((a,b) => {resolve=a; reject=b;}); return {promise,resolve,reject}; };
async function test() {
    let saves=0, previews=0, errors=0, closed=0, applied=null, busy=false;
    let save = deferred(), load = deferred();
    const flow=create({persist:()=>{saves++; return save.promise;}, load:()=>load.promise,
        apply:result=>{applied=result;}, close:()=>{closed++;}, busy:value=>{busy=value;},
        saved:()=>{}, error:()=>{errors++;}, preview:()=>{assert.equal(flow.pending(),false); previews++;}});
    const first=flow.save(true);
    await Promise.resolve();
    assert.equal(previews,0); assert.equal(saves,1); assert.equal(busy,true);
    assert.equal(flow.save(true),first);
    save.resolve({success:true}); await first;
    assert.equal(previews,1); assert.equal(saves,1); assert.equal(busy,false);
    console.log('[PASS] Save and show waits for acknowledgement; double click saves/navigates once');

    save=deferred(); const failed=flow.save(true); save.resolve({success:false,message:'DB failure'}); await failed;
    assert.equal(previews,1); assert.equal(errors,1); assert.equal(busy,false);
    save=deferred(); const aborted=flow.save(true); save.reject(new Error('aborted')); await aborted;
    assert.equal(previews,1); assert.equal(errors,2); assert.equal(flow.pending(),false);
    console.log('[PASS] Server rejection and aborted network do not navigate and permit retry');

    save=deferred(); load=deferred(); const selection=flow.select(2);
    await Promise.resolve(); assert.equal(applied,null); assert.equal(closed,0);
    load.resolve({success:true,id:2,template:'FISCAL'});
    await Promise.resolve(); await Promise.resolve();
    assert.equal(applied.id,2); assert.equal(closed,0);
    flow.save(true); // Preview clicked while template selection is being saved.
    assert.equal(previews,1);
    save.resolve({success:true,proposal_template_id:2}); await selection;
    assert.equal(previews,2); assert.equal(closed,1); assert.equal(busy,false);
    console.log('[PASS] Selection persists before modal closes or preview navigates');

    save=deferred(); const retry=flow.save(false); save.resolve({success:true}); await retry;
    assert.equal(previews,2);
    console.log('[PASS] A later ordinary save does not inherit stale navigation intent');
}
test().catch(e=>{console.error(e); process.exitCode=1;});
