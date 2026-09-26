(function (root, factory) {
    if (typeof module === 'object' && module.exports) module.exports = factory();
    else root.ProposalEditorSave = factory();
}(typeof window !== 'undefined' ? window : this, function () {
    'use strict';
    return function (io) {
        var pending = null, showAfterSave = false;
        function run(task, show) {
            showAfterSave = showAfterSave || !!show;
            if (pending) return pending;
            io.busy(true);
            pending = Promise.resolve().then(task).then(function (result) {
                if (!result || !result.success) throw new Error(result && result.message || 'No fue posible guardar la propuesta.');
                io.saved(result);
                if (showAfterSave) {
                    pending = null; // The confirmed save must not trigger the beforeunload guard.
                    io.preview();
                }
                return result;
            }).catch(function (error) {
                io.error(error.message || 'No se confirmó el guardado. Intenta de nuevo.');
                return {success: false};
            }).finally(function () {
                pending = null;
                showAfterSave = false;
                io.busy(false);
            });
            return pending;
        }
        return {
            save: function (show) { return run(function () { return io.persist(); }, show); },
            select: function (id) {
                return run(function () {
                    return io.load(id).then(function (result) {
                        if (!result.success) throw new Error(result.message || 'No fue posible cargar la plantilla.');
                        io.apply(result);
                        return io.persist().then(function (saved) {
                            if (saved.success) io.close();
                            return saved;
                        });
                    });
                }, false);
            },
            pending: function () { return !!pending; }
        };
    };
}));
